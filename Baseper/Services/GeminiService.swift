import Foundation

actor GeminiService: TranscriptionProvider {

    // MARK: - TranscriptionProvider Protocol

    let providerID: ProviderID = .gemini
    let displayName: String = "Google Gemini"
    let maxConcurrentUploads: Int = 3

    var availableModels: [TranscriptionModel] {
        [
            TranscriptionModel(
                id: "gemini-2.5-flash-lite",
                displayName: "Gemini 2.5 Flash-Lite",
                costPerHour: 0.039,  // 90K audio input @ $0.30/1M + 30K output @ $0.40/1M
                speedFactor: nil,
                errorRate: nil
            )
        ]
    }

    // MARK: - Private Properties

    private let baseEndpoint = "https://generativelanguage.googleapis.com/v1beta/models"
    private var currentModel: String = "gemini-2.5-flash-lite"
    private var apiKey: String = ""
    private var session: URLSession

    // Track active uploads
    private var activeUploads: Set<UUID> = []

    // MARK: - Initialization

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }

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
        // Test the API key by making a simple request
        guard !apiKey.isEmpty else {
            throw ProviderError.invalidAPIKey
        }

        // Construct a test URL
        let testEndpoint = "\(baseEndpoint)/\(currentModel):generateContent?key=\(apiKey)"
        guard let url = URL(string: testEndpoint) else {
            throw ProviderError.networkError("Invalid URL")
        }

        // Simple test request
        let requestBody: [String: Any] = [
            "contents": [
                ["parts": [["text": "Hello"]]]
            ]
        ]

        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw ProviderError.invalidResponse("Invalid response type")
            }

            if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
                throw ProviderError.invalidAPIKey
            } else if httpResponse.statusCode == 200 {
                return true
            } else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw ProviderError.networkError("HTTP \(httpResponse.statusCode): \(errorMessage)")
            }
        } catch let error as ProviderError {
            throw error
        } catch {
            throw ProviderError.networkError(error.localizedDescription)
        }
    }

    // MARK: - Transcription

    /// Upload audio chunk and get transcription
    /// Returns GhostID immediately for non-blocking operation
    func uploadAudioChunk(_ wavData: Data, ghostID: UUID = UUID()) async throws -> (ghostID: UUID, transcription: String) {
        guard !apiKey.isEmpty else {
            throw ProviderError.invalidAPIKey
        }

        // Wait if too many concurrent uploads
        while activeUploads.count >= maxConcurrentUploads {
            try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        }

        activeUploads.insert(ghostID)
        defer { Task { await self.removeActiveUpload(ghostID) } }

        // Construct URL with API key using current model
        let endpoint = "\(baseEndpoint)/\(currentModel):generateContent"
        guard let url = URL(string: "\(endpoint)?key=\(apiKey)") else {
            throw ProviderError.networkError("Invalid URL")
        }

        // Base64 encode WAV data
        let base64Audio = wavData.base64EncodedString()

        // Construct request body
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        [
                            "text": "Transcribe this audio exactly as spoken."
                        ],
                        [
                            "inline_data": [
                                "mime_type": "audio/wav",
                                "data": base64Audio
                            ]
                        ]
                    ]
                ]
            ],
            "systemInstruction": [
                "parts": [
                    ["text": "You are a transcription assistant. Output only the transcribed text, without any commentary, labels, or additional information."]
                ]
            ],
            "generationConfig": [
                "temperature": 0.1,
                "maxOutputTokens": 1000
            ]
        ]

        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)

        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        print("📤 Uploading audio chunk \(ghostID) (\(wavData.count) bytes)")

        // Send request
        let (data, response) = try await session.data(for: request)

        // Check response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ProviderError.invalidResponse("Invalid response type")
        }

        // Handle error status codes
        if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
            throw ProviderError.invalidAPIKey
        } else if httpResponse.statusCode == 429 {
            throw ProviderError.rateLimitExceeded
        } else if httpResponse.statusCode != 200 {
            if let errorString = String(data: data, encoding: .utf8) {
                print("❌ API Error (\(httpResponse.statusCode)): \(errorString)")
            }
            throw ProviderError.networkError("HTTP \(httpResponse.statusCode)")
        }

        // Parse response
        let transcription = try parseResponse(data)
        print("✅ Transcription for \(ghostID): \(transcription)")

        return (ghostID, transcription)
    }

    private func removeActiveUpload(_ ghostID: UUID) {
        activeUploads.remove(ghostID)
    }

    /// Parse Gemini API response to extract transcribed text
    private func parseResponse(_ data: Data) throws -> String {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw ProviderError.invalidResponse("Invalid JSON")
        }

        // Check for error
        if let error = json["error"] as? [String: Any],
           let message = error["message"] as? String {
            throw ProviderError.networkError(message)
        }

        // Extract text from candidates
        guard let candidates = json["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first,
              let content = firstCandidate["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let firstPart = parts.first,
              let text = firstPart["text"] as? String else {
            throw ProviderError.invalidResponse("Could not extract text from response")
        }

        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
