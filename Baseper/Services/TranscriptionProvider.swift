//
//  TranscriptionProvider.swift
//  Baseper
//
//  Protocol abstraction for multi-provider transcription support
//

import Foundation

// MARK: - Provider Protocol

/// Protocol that all transcription providers must implement
protocol TranscriptionProvider: Actor {
    /// Unique identifier for this provider
    var providerID: ProviderID { get }

    /// Display name shown in UI
    var displayName: String { get }

    /// List of models available for this provider
    var availableModels: [TranscriptionModel] { get }

    /// Maximum number of concurrent upload operations
    var maxConcurrentUploads: Int { get }

    /// Configure the API key for this provider
    func setAPIKey(_ key: String)

    /// Select which model to use for transcription
    func setModel(_ modelID: String)

    /// Upload an audio chunk and get transcription
    /// - Parameters:
    ///   - wavData: Audio data in WAV format
    ///   - ghostID: Unique identifier for this chunk
    /// - Returns: Tuple of ghostID and transcription text
    func uploadAudioChunk(_ wavData: Data, ghostID: UUID) async throws -> (ghostID: UUID, transcription: String)

    /// Validate that the API key is working
    /// - Returns: True if API key is valid
    func validateAPIKey() async throws -> Bool
}

// MARK: - Provider ID

/// Enumeration of supported transcription providers
enum ProviderID: String, CaseIterable, Codable {
    case gemini = "gemini"
    case groq = "groq"

    var displayName: String {
        switch self {
        case .gemini:
            return "Google Gemini"
        case .groq:
            return "Groq"
        }
    }

    var apiKeyURL: String {
        switch self {
        case .gemini:
            return "https://aistudio.google.com/app/apikey"
        case .groq:
            return "https://console.groq.com/keys"
        }
    }
}

// MARK: - Transcription Model

/// Represents a specific transcription model with its characteristics
struct TranscriptionModel: Identifiable, Codable, Hashable {
    /// Unique model identifier (e.g., "gemini-2.5-flash-lite")
    let id: String

    /// Human-readable name for display
    let displayName: String

    /// Cost per hour of audio in USD
    let costPerHour: Double

    /// Speed multiplier (e.g., 216x real-time), nil if not specified
    let speedFactor: Double?

    /// Word error rate, nil if not specified
    let errorRate: Double?

    /// Formatted cost string for display
    var formattedCost: String {
        return String(format: "$%.3f/hr", costPerHour)
    }

    /// Secondary info line (speed and/or error rate)
    var secondaryInfo: String? {
        var parts: [String] = []
        if let speed = speedFactor {
            parts.append("\(Int(speed))x speed")
        }
        if let error = errorRate {
            parts.append("\(String(format: "%.1f%%", error * 100)) WER")
        }
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }
}

// MARK: - Provider Errors

enum ProviderError: LocalizedError {
    case invalidAPIKey
    case networkError(String)
    case invalidResponse(String)
    case modelNotSupported(String)
    case rateLimitExceeded

    var errorDescription: String? {
        switch self {
        case .invalidAPIKey:
            return "Invalid API key. Please check your credentials."
        case .networkError(let message):
            return "Network error: \(message)"
        case .invalidResponse(let message):
            return "Invalid response: \(message)"
        case .modelNotSupported(let model):
            return "Model not supported: \(model)"
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again later."
        }
    }
}
