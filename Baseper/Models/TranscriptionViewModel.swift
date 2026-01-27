import Foundation
import AppKit

@MainActor
class TranscriptionViewModel: ObservableObject {
    @Published var transcriptionText: NSAttributedString = NSAttributedString(string: "")
    @Published var sessionState: SessionState = .idle
    @Published var statusMessage: String = "Ready"
    @Published var hasAPIKey: Bool = false
    @Published var showingError: Bool = false
    @Published var errorMessage: String = ""

    let providerManager = ProviderManager.shared
    private let audioService = AudioCaptureService()

    // Chunk tracking
    private var chunks: [TranscriptionChunk] = []
    private var pendingUploads: Set<UUID> = []

    init() {
        updateAPIKey()
        setupAudioCallback()
    }

    func updateAPIKey() {
        let providerID = providerManager.selectedProviderID
        hasAPIKey = KeychainManager.shared.getAPIKey(for: providerID) != nil
        if hasAPIKey {
            statusMessage = "Ready"
        } else {
            statusMessage = "API key not configured"
        }
    }

    private func setupAudioCallback() {
        // Handle audio chunks from VAD
        audioService.onAudioChunk = { [weak self] wavData in
            guard let self = self else { return }
            Task {
                await self.handleAudioChunk(wavData)
            }
        }

        // Handle auto-stop after 30s silence
        audioService.onAutoStop = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.stopRecording()
            }
        }
    }

    func startRecording() {
        let providerID = providerManager.selectedProviderID
        guard let apiKey = KeychainManager.shared.getAPIKey(for: providerID) else {
            showError("Please configure your \(providerID.displayName) API key in Settings")
            return
        }

        // Smart clear logic
        if case .finalized = sessionState {
            // Auto-clear after Copy
            chunks.removeAll()
            pendingUploads.removeAll()
            transcriptionText = NSAttributedString(string: "")
        }
        // Otherwise append mode (don't clear)

        statusMessage = "Starting..."

        Task {
            do {
                // Get provider dynamically
                let provider = await providerManager.getProvider()
                await provider.setAPIKey(apiKey)

                // Start audio capture
                try audioService.startRecording()

                sessionState = .recording(startTime: Date())
                statusMessage = "Recording..."
                print("✅ Recording started with \(providerID.displayName)")

            } catch {
                print("Error starting recording: \(error)")
                showError("Failed to start recording: \(error.localizedDescription)")
                statusMessage = "Error - check console"
                sessionState = .idle
            }
        }
    }

    func stopRecording() {
        audioService.stopRecording()

        // Transition to review state if we have chunks
        if !chunks.isEmpty {
            sessionState = .review(chunks: chunks)

            // Update status with pending count
            if pendingUploads.isEmpty {
                statusMessage = "Ready"
            } else {
                statusMessage = "Processing \(pendingUploads.count) chunks..."
            }
        } else {
            sessionState = .idle
            statusMessage = "Ready"
        }
    }

    private func handleAudioChunk(_ wavData: Data) async {
        // Create ghost chunk with placeholder text
        let ghostID = UUID()
        let ghostChunk = TranscriptionChunk(
            id: ghostID,
            text: "( ... )",
            status: .uploading,
            timestamp: Date()
        )

        // Add to chunks and rebuild text
        chunks.append(ghostChunk)
        pendingUploads.insert(ghostID)
        rebuildAttributedText()
        updateStatusMessage()

        // Upload in background
        Task {
            do {
                // Get provider dynamically
                let provider = await providerManager.getProvider()
                let (_, transcription) = try await provider.uploadAudioChunk(wavData, ghostID: ghostID)

                // Update chunk with transcribed text
                await updateChunk(ghostID: ghostID, text: transcription)

            } catch {
                print("❌ Upload error for \(ghostID): \(error)")
                await markChunkFailed(ghostID: ghostID, error: error)
            }
        }
    }

    private func updateChunk(ghostID: UUID, text: String) {
        guard let index = chunks.firstIndex(where: { $0.id == ghostID }) else { return }

        chunks[index].text = text
        chunks[index].status = .completed
        pendingUploads.remove(ghostID)

        rebuildAttributedText()
        updateStatusMessage()
    }

    private func markChunkFailed(ghostID: UUID, error: Error) {
        guard let index = chunks.firstIndex(where: { $0.id == ghostID }) else { return }

        chunks[index].text = "[Error: \(error.localizedDescription)]"
        chunks[index].status = .failed
        pendingUploads.remove(ghostID)

        rebuildAttributedText()
        updateStatusMessage()
    }

    private func rebuildAttributedText() {
        let attributedString = NSMutableAttributedString()

        for (index, chunk) in chunks.enumerated() {
            // Add space between chunks
            if index > 0 {
                attributedString.append(NSAttributedString(string: " "))
            }

            // Color based on status
            let color: NSColor
            switch chunk.status {
            case .uploading:
                color = .gray
            case .completed:
                color = .labelColor  // Black in light mode, white in dark mode
            case .failed:
                color = .red
            }

            let chunkString = NSAttributedString(
                string: chunk.text,
                attributes: [
                    .foregroundColor: color,
                    .font: NSFont.systemFont(ofSize: 13)
                ]
            )

            attributedString.append(chunkString)
        }

        transcriptionText = attributedString
    }

    private func updateStatusMessage() {
        if case .recording = sessionState {
            if pendingUploads.isEmpty {
                statusMessage = "Recording..."
            } else {
                statusMessage = "Recording (processing \(pendingUploads.count) chunks...)"
            }
        } else if case .review = sessionState {
            if pendingUploads.isEmpty {
                statusMessage = "Ready"
            } else {
                statusMessage = "Processing \(pendingUploads.count) chunks..."
            }
        }
    }

    func copyToClipboard() {
        // Extract plain text from chunks
        let plainText = chunks
            .filter { $0.status == .completed }
            .map { $0.text }
            .joined(separator: " ")

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(plainText, forType: .string)

        statusMessage = "Copied to clipboard!"

        // Clear transcription after copying
        clearTranscription()
    }

    func clearTranscription() {
        chunks.removeAll()
        pendingUploads.removeAll()
        transcriptionText = NSAttributedString(string: "")
        sessionState = .idle
        statusMessage = "Ready"
    }

    func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}
