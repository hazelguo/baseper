import Foundation
import AVFoundation

class AudioCaptureService {
    private var audioEngine: AVAudioEngine?
    private var inputNode: AVAudioInputNode?

    // Callbacks
    var onAudioChunk: ((Data) -> Void)?  // Called with WAV file data
    var onAutoStop: (() -> Void)?        // Called when 30s of silence detected

    // VAD settings
    private var silenceThresholdDB: Float = -45.0
    private var silenceBufferCount: Int = 0
    private let silenceBufferThreshold: Int = 11  // ~0.7s at 64ms buffers
    private var totalSilenceCount: Int = 0
    private let autoStopThreshold: Int = 470  // ~30s

    // Buffering
    private var preRollBuffer: CircularAudioBuffer!
    private var currentChunkBuffer: Data = Data()
    private var isRecordingSpeech: Bool = false
    private var chunkStartTime: Date?
    private let sampleRate: Int = 16000
    private let maxChunkDuration: TimeInterval = 25.0  // Hard cut at 25s

    func startRecording() throws {
        // Request microphone permission
        let audioSession = AVCaptureDevice.authorizationStatus(for: .audio)

        guard audioSession == .authorized else {
            if audioSession == .notDetermined {
                AVCaptureDevice.requestAccess(for: .audio) { [weak self] granted in
                    if granted {
                        // After permission granted, call startRecording again
                        try? self?.startRecording()
                    }
                }
                return
            }
            throw AudioError.permissionDenied
        }

        // Initialize pre-roll buffer (200ms at 16kHz = 3200 samples = 6400 bytes)
        preRollBuffer = CircularAudioBuffer(capacity: 6400)

        // Reset VAD state
        silenceBufferCount = 0
        totalSilenceCount = 0
        isRecordingSpeech = false
        currentChunkBuffer = Data()

        try setupAudioEngine()
    }

    func stopRecording() {
        // Finalize any pending chunk
        if !currentChunkBuffer.isEmpty {
            finalizeChunk()
        }

        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        audioEngine = nil
        inputNode = nil
    }

    private func setupAudioEngine() throws {
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else {
            throw AudioError.engineCreationFailed
        }

        inputNode = audioEngine.inputNode
        guard let inputNode = inputNode else {
            throw AudioError.noInputNode
        }

        // Gemini expects 16-bit PCM at 16kHz
        let recordingFormat = AVAudioFormat(
            commonFormat: .pcmFormatInt16,
            sampleRate: 16000,
            channels: 1,
            interleaved: true
        )

        guard let recordingFormat = recordingFormat else {
            throw AudioError.invalidFormat
        }

        // Get the input format
        let inputFormat = inputNode.outputFormat(forBus: 0)

        // Create converter if needed
        guard let converter = AVAudioConverter(from: inputFormat, to: recordingFormat) else {
            throw AudioError.converterCreationFailed
        }

        // Install tap on the input node
        inputNode.installTap(onBus: 0, bufferSize: 4096, format: inputFormat) { [weak self] buffer, _ in
            self?.processAudioBuffer(buffer, converter: converter, outputFormat: recordingFormat)
        }

        // Start the audio engine
        try audioEngine.start()
    }

    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer, converter: AVAudioConverter, outputFormat: AVAudioFormat) {
        // Calculate output buffer size
        let capacity = AVAudioFrameCount(Double(buffer.frameLength) * outputFormat.sampleRate / buffer.format.sampleRate)

        guard let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: capacity) else {
            return
        }

        var error: NSError?
        let inputBlock: AVAudioConverterInputBlock = { inNumPackets, outStatus in
            outStatus.pointee = .haveData
            return buffer
        }

        converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputBlock)

        if let error = error {
            print("Conversion error: \(error)")
            return
        }

        // Convert to Data
        guard let channelData = convertedBuffer.int16ChannelData else { return }
        let channelDataPointer = channelData.pointee
        let dataSize = Int(convertedBuffer.frameLength) * MemoryLayout<Int16>.size
        let data = Data(bytes: channelDataPointer, count: dataSize)

        // Safety check: ensure buffer is initialized
        guard let preRollBuffer = preRollBuffer else {
            print("⚠️ Pre-roll buffer not initialized, skipping audio buffer")
            return
        }

        // VAD: Calculate RMS
        let rmsDB = calculateRMS(from: data)

        // Add to pre-roll buffer
        preRollBuffer.append(data)

        // Detect speech vs silence
        if rmsDB > silenceThresholdDB {
            // Speech detected
            if !isRecordingSpeech {
                startNewChunk()
            }

            currentChunkBuffer.append(data)
            silenceBufferCount = 0
            totalSilenceCount = 0

            // Check for 25s hard cut
            if let startTime = chunkStartTime,
               Date().timeIntervalSince(startTime) >= maxChunkDuration {
                print("⏱️ 25s hard cut triggered")
                finalizeChunk()
            }
        } else {
            // Silence detected
            silenceBufferCount += 1
            totalSilenceCount += 1

            if isRecordingSpeech {
                currentChunkBuffer.append(data)

                // Check for 0.7s silence to finalize chunk
                if silenceBufferCount >= silenceBufferThreshold {
                    print("🔇 0.7s silence detected, finalizing chunk")
                    finalizeChunk()
                }
            }

            // Check for 30s auto-stop
            if totalSilenceCount >= autoStopThreshold {
                print("⏹️ 30s of silence detected, auto-stopping")
                DispatchQueue.main.async { [weak self] in
                    self?.onAutoStop?()
                }
                totalSilenceCount = 0  // Reset to avoid repeated triggers
            }
        }
    }

    private func calculateRMS(from data: Data) -> Float {
        let samples = data.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) -> [Int16] in
            let buffer = ptr.bindMemory(to: Int16.self)
            return Array(buffer)
        }

        guard !samples.isEmpty else { return -100.0 }

        // Calculate RMS
        let sumOfSquares = samples.reduce(0.0) { $0 + pow(Float($1), 2) }
        let rms = sqrt(sumOfSquares / Float(samples.count))

        // Convert to dB (reference: max Int16 value)
        let db = 20 * log10(rms / 32768.0)
        return db
    }

    private func startNewChunk() {
        isRecordingSpeech = true
        chunkStartTime = Date()

        // Initialize chunk with pre-roll data
        currentChunkBuffer = preRollBuffer.getData()
        print("🎤 Started new chunk with \(currentChunkBuffer.count) bytes pre-roll")
    }

    private func finalizeChunk() {
        guard !currentChunkBuffer.isEmpty else { return }

        // Create WAV file
        let wavData = createWAVFile(from: currentChunkBuffer, sampleRate: sampleRate)

        print("📦 Finalized chunk: \(currentChunkBuffer.count) bytes PCM → \(wavData.count) bytes WAV")

        // Send chunk callback
        onAudioChunk?(wavData)

        // Reset chunk state
        currentChunkBuffer = Data()
        isRecordingSpeech = false
        chunkStartTime = nil
        silenceBufferCount = 0
    }

    private func createWAVFile(from pcmData: Data, sampleRate: Int) -> Data {
        let numChannels: UInt16 = 1
        let bitsPerSample: UInt16 = 16
        let byteRate = UInt32(sampleRate * Int(numChannels) * Int(bitsPerSample) / 8)
        let blockAlign = UInt16(numChannels * bitsPerSample / 8)
        let dataSize = UInt32(pcmData.count)

        var wavHeader = Data()

        // RIFF header
        wavHeader.append("RIFF".data(using: .ascii)!)
        wavHeader.append(withUnsafeBytes(of: (36 + dataSize).littleEndian) { Data($0) })
        wavHeader.append("WAVE".data(using: .ascii)!)

        // fmt chunk
        wavHeader.append("fmt ".data(using: .ascii)!)
        wavHeader.append(withUnsafeBytes(of: UInt32(16).littleEndian) { Data($0) })  // Subchunk size
        wavHeader.append(withUnsafeBytes(of: UInt16(1).littleEndian) { Data($0) })   // Audio format (PCM)
        wavHeader.append(withUnsafeBytes(of: numChannels.littleEndian) { Data($0) })
        wavHeader.append(withUnsafeBytes(of: UInt32(sampleRate).littleEndian) { Data($0) })
        wavHeader.append(withUnsafeBytes(of: byteRate.littleEndian) { Data($0) })
        wavHeader.append(withUnsafeBytes(of: blockAlign.littleEndian) { Data($0) })
        wavHeader.append(withUnsafeBytes(of: bitsPerSample.littleEndian) { Data($0) })

        // data chunk
        wavHeader.append("data".data(using: .ascii)!)
        wavHeader.append(withUnsafeBytes(of: dataSize.littleEndian) { Data($0) })

        // Combine header and PCM data
        var wavFile = wavHeader
        wavFile.append(pcmData)

        return wavFile
    }
}

// Circular buffer for pre-roll audio
class CircularAudioBuffer {
    private var buffer: Data
    private let capacity: Int
    private var writePosition: Int = 0
    private var isFull: Bool = false

    init(capacity: Int) {
        self.capacity = capacity
        self.buffer = Data(count: capacity)
    }

    func append(_ data: Data) {
        for byte in data {
            buffer[writePosition] = byte
            writePosition = (writePosition + 1) % capacity

            if writePosition == 0 {
                isFull = true
            }
        }
    }

    func getData() -> Data {
        if isFull {
            // Return ordered data starting from writePosition
            let firstPart = buffer[writePosition..<capacity]
            let secondPart = buffer[0..<writePosition]
            return firstPart + secondPart
        } else {
            // Buffer not full yet, return what we have
            return Data(buffer[0..<writePosition])
        }
    }
}

enum AudioError: Error {
    case permissionDenied
    case engineCreationFailed
    case noInputNode
    case invalidFormat
    case converterCreationFailed
}
