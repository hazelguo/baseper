//
//  GroqService.swift
//  Baseper
//
//  Groq Whisper transcription service implementation
//

import Foundation

actor GroqService: TranscriptionProvider {

    // MARK: - TranscriptionProvider Protocol

    let providerID: ProviderID = .groq
    let displayName: String = "Groq"
    let maxConcurrentUploads: Int = 3

    var availableModels: [TranscriptionModel] {
        [
            TranscriptionModel(
                id: "distil-whisper-large-v3-en",
                displayName: "Distil-Whisper (English)",
                costPerHour: 0.02,  // CHEAPEST option
                speedFactor: nil,
                errorRate: nil
            ),
            TranscriptionModel(
                id: "whisper-large-v3-turbo",
                displayName: "Whisper Large V3 Turbo",
                costPerHour: 0.04,
                speedFactor: 216,
                errorRate: 0.12
            )
        ]
    }

    // MARK: - Private Properties

    private var apiKey: String = ""
    private var currentModel: String = "distil-whisper-large-v3-en"  // Default to cheapest
    private let endpoint = "https://api.groq.com/openai/v1/audio/transcriptions"

    // Semaphore to limit concurrent uploads
    private var uploadSemaphore: Int = 0

    // MARK: - Configuration

    func setAPIKey(_ key: String) {
        self.apiKey = key
    }

    func setModel(_ modelID: String) {
        // Validate model is supported
        if availableModels.contains(where: { $0.id == modelID }) {
            self.currentModel = modelID
        } else {
            print("⚠️ Model \(modelID) not supported, using default: \(currentModel)")
        }
    }

    // MARK: - API Validation

    func validateAPIKey() async throws -> Bool {
        // Test the API key by making a small test request
        // We'll create a minimal WAV file for testing
        let testWAV = createSilentWAV(durationSeconds: 0.1)

        do {
            _ = try await uploadAudioChunk(testWAV, ghostID: UUID())
            return true
        } catch {
            throw ProviderError.invalidAPIKey
        }
    }

    // MARK: - Transcription

    func uploadAudioChunk(_ wavData: Data, ghostID: UUID) async throws -> (ghostID: UUID, transcription: String) {
        // Wait if we're at max concurrent uploads
        while uploadSemaphore >= maxConcurrentUploads {
            try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        }

        uploadSemaphore += 1
        defer { uploadSemaphore -= 1 }

        do {
            let transcription = try await performUpload(wavData)
            return (ghostID: ghostID, transcription: transcription)
        } catch {
            print("❌ Groq upload failed: \(error)")
            throw error
        }
    }

    // MARK: - Private Methods

    private func performUpload(_ wavData: Data) async throws -> String {
        guard !apiKey.isEmpty else {
            throw ProviderError.invalidAPIKey
        }

        guard let url = URL(string: endpoint) else {
            throw ProviderError.networkError("Invalid endpoint URL")
        }

        // Create multipart form-data request
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Build multipart body
        var body = Data()

        // Add file field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.wav\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
        body.append(wavData)
        body.append("\r\n".data(using: .utf8)!)

        // Add model field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(currentModel)\r\n".data(using: .utf8)!)

        // Add language field (optional, but improves accuracy for English)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"language\"\r\n\r\n".data(using: .utf8)!)
        body.append("en\r\n".data(using: .utf8)!)

        // Add response format field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"response_format\"\r\n\r\n".data(using: .utf8)!)
        body.append("json\r\n".data(using: .utf8)!)

        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // Set timeout
        request.timeoutInterval = 30.0

        // Perform request
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ProviderError.networkError("Invalid response type")
        }

        // Check for errors
        if httpResponse.statusCode == 401 {
            throw ProviderError.invalidAPIKey
        } else if httpResponse.statusCode == 429 {
            throw ProviderError.rateLimitExceeded
        } else if httpResponse.statusCode != 200 {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw ProviderError.networkError("HTTP \(httpResponse.statusCode): \(errorMessage)")
        }

        // Parse response
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let text = json["text"] as? String else {
            let responseString = String(data: data, encoding: .utf8) ?? "Unable to parse"
            throw ProviderError.invalidResponse("Expected {\"text\": \"...\"}, got: \(responseString)")
        }

        return text
    }

    /// Create a minimal silent WAV file for API key validation
    private func createSilentWAV(durationSeconds: Double) -> Data {
        let sampleRate = 16000
        let numSamples = Int(Double(sampleRate) * durationSeconds)
        let numChannels = 1
        let bitsPerSample = 16

        var wavData = Data()

        // WAV header
        let chunkSize = UInt32(36 + numSamples * numChannels * bitsPerSample / 8)
        let subchunk1Size = UInt32(16)
        let audioFormat = UInt16(1) // PCM
        let numChannelsU16 = UInt16(numChannels)
        let sampleRateU32 = UInt32(sampleRate)
        let byteRate = UInt32(sampleRate * numChannels * bitsPerSample / 8)
        let blockAlign = UInt16(numChannels * bitsPerSample / 8)
        let bitsPerSampleU16 = UInt16(bitsPerSample)
        let subchunk2Size = UInt32(numSamples * numChannels * bitsPerSample / 8)

        wavData.append("RIFF".data(using: .utf8)!)
        wavData.append(withUnsafeBytes(of: chunkSize.littleEndian) { Data($0) })
        wavData.append("WAVE".data(using: .utf8)!)
        wavData.append("fmt ".data(using: .utf8)!)
        wavData.append(withUnsafeBytes(of: subchunk1Size.littleEndian) { Data($0) })
        wavData.append(withUnsafeBytes(of: audioFormat.littleEndian) { Data($0) })
        wavData.append(withUnsafeBytes(of: numChannelsU16.littleEndian) { Data($0) })
        wavData.append(withUnsafeBytes(of: sampleRateU32.littleEndian) { Data($0) })
        wavData.append(withUnsafeBytes(of: byteRate.littleEndian) { Data($0) })
        wavData.append(withUnsafeBytes(of: blockAlign.littleEndian) { Data($0) })
        wavData.append(withUnsafeBytes(of: bitsPerSampleU16.littleEndian) { Data($0) })
        wavData.append("data".data(using: .utf8)!)
        wavData.append(withUnsafeBytes(of: subchunk2Size.littleEndian) { Data($0) })

        // Silent audio data (zeros)
        let silentData = Data(repeating: 0, count: numSamples * numChannels * bitsPerSample / 8)
        wavData.append(silentData)

        return wavData
    }
}
