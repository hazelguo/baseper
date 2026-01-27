//
//  ProviderManager.swift
//  Baseper
//
//  Manages transcription provider selection and instantiation
//

import Foundation

@MainActor
class ProviderManager: ObservableObject {
    static let shared = ProviderManager()

    // MARK: - Published Properties

    @Published var selectedProviderID: ProviderID {
        didSet {
            KeychainManager.shared.saveSelectedProvider(selectedProviderID)
            // Reset current provider to force re-instantiation
            currentProvider = nil
        }
    }

    @Published var selectedModelID: String? {
        didSet {
            if let modelID = selectedModelID {
                KeychainManager.shared.saveSelectedModel(for: selectedProviderID, modelID: modelID)
            }
        }
    }

    // MARK: - Private Properties

    private var currentProvider: (any TranscriptionProvider)?

    // MARK: - Initialization

    private init() {
        // Load saved provider or default to Gemini
        self.selectedProviderID = KeychainManager.shared.getSelectedProvider() ?? .gemini

        // Load saved model for the selected provider
        self.selectedModelID = KeychainManager.shared.getSelectedModel(for: selectedProviderID)
    }

    // MARK: - Provider Access

    /// Get the currently selected provider instance, creating it if needed
    func getProvider() async -> any TranscriptionProvider {
        // If we already have a provider instance for the selected provider, return it
        if let provider = currentProvider,
           await provider.providerID == selectedProviderID {
            return provider
        }

        // Create new provider instance
        let provider = await createProvider(selectedProviderID)
        currentProvider = provider
        return provider
    }

    // MARK: - Provider Management

    /// Set the active provider and model
    func setProvider(_ providerID: ProviderID, modelID: String) async {
        self.selectedProviderID = providerID
        self.selectedModelID = modelID

        // Configure the provider
        if let provider = currentProvider {
            await provider.setModel(modelID)

            // Configure API key if available
            if let apiKey = KeychainManager.shared.getAPIKey(for: providerID) {
                await provider.setAPIKey(apiKey)
            }
        }
    }

    /// Get available models for a specific provider
    func getAvailableModels(for providerID: ProviderID) async -> [TranscriptionModel] {
        let provider = await createProvider(providerID)
        return await provider.availableModels
    }

    /// Get available models for the currently selected provider
    func getAvailableModels() async -> [TranscriptionModel] {
        return await getAvailableModels(for: selectedProviderID)
    }

    /// Check if the current provider has a valid API key configured
    func hasAPIKey() -> Bool {
        return KeychainManager.shared.getAPIKey(for: selectedProviderID) != nil
    }

    /// Get the API key for the current provider
    func getAPIKey() -> String? {
        return KeychainManager.shared.getAPIKey(for: selectedProviderID)
    }

    /// Save API key for the current provider
    func saveAPIKey(_ apiKey: String) -> Bool {
        return KeychainManager.shared.saveAPIKey(apiKey, for: selectedProviderID)
    }

    // MARK: - Private Methods

    private func createProvider(_ providerID: ProviderID) async -> any TranscriptionProvider {
        let provider: any TranscriptionProvider

        switch providerID {
        case .gemini:
            provider = GeminiService()

        case .groq:
            provider = GroqService()
        }

        // Configure with saved settings
        if let apiKey = KeychainManager.shared.getAPIKey(for: providerID) {
            await provider.setAPIKey(apiKey)
        }

        if let modelID = KeychainManager.shared.getSelectedModel(for: providerID) {
            await provider.setModel(modelID)
        }

        return provider
    }
}
