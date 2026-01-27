import Foundation

class KeychainManager {
    static let shared = KeychainManager()

    // Legacy key for migration
    private let legacyAPIKeyKey = "geminiAPIKey"

    // Keys for provider selection
    private let selectedProviderKey = "selectedProvider"
    private let selectedModelPrefix = "selectedModel_"

    private init() {}

    // Using UserDefaults for simple, transparent storage
    // Stored in ~/Library/Preferences/com.hazelguo.Baseper.plist
    // Users can clear with: defaults delete com.hazelguo.Baseper

    // MARK: - Provider Selection

    func saveSelectedProvider(_ providerID: ProviderID) {
        UserDefaults.standard.set(providerID.rawValue, forKey: selectedProviderKey)
    }

    func getSelectedProvider() -> ProviderID? {
        guard let rawValue = UserDefaults.standard.string(forKey: selectedProviderKey) else {
            return nil
        }
        return ProviderID(rawValue: rawValue)
    }

    // MARK: - Model Selection

    func saveSelectedModel(for providerID: ProviderID, modelID: String) {
        let key = "\(selectedModelPrefix)\(providerID.rawValue)"
        UserDefaults.standard.set(modelID, forKey: key)
    }

    func getSelectedModel(for providerID: ProviderID) -> String? {
        let key = "\(selectedModelPrefix)\(providerID.rawValue)"
        return UserDefaults.standard.string(forKey: key)
    }

    // MARK: - API Key Storage (Per-Provider)

    func saveAPIKey(_ apiKey: String, for providerID: ProviderID) -> Bool {
        let key = apiKeyKey(for: providerID)
        UserDefaults.standard.set(apiKey, forKey: key)
        return true
    }

    func getAPIKey(for providerID: ProviderID) -> String? {
        let key = apiKeyKey(for: providerID)
        return UserDefaults.standard.string(forKey: key)
    }

    func deleteAPIKey(for providerID: ProviderID) {
        let key = apiKeyKey(for: providerID)
        UserDefaults.standard.removeObject(forKey: key)
    }

    private func apiKeyKey(for providerID: ProviderID) -> String {
        return "\(providerID.rawValue)APIKey"  // e.g., "geminiAPIKey", "groqAPIKey"
    }

    // MARK: - Legacy Methods (for backward compatibility)

    @available(*, deprecated, message: "Use saveAPIKey(_:for:) instead")
    func saveAPIKey(_ apiKey: String) -> Bool {
        // Default to Gemini for legacy code
        return saveAPIKey(apiKey, for: .gemini)
    }

    @available(*, deprecated, message: "Use getAPIKey(for:) instead")
    func getAPIKey() -> String? {
        // Default to Gemini for legacy code
        return getAPIKey(for: .gemini)
    }

    @available(*, deprecated, message: "Use deleteAPIKey(for:) instead")
    func deleteAPIKey() {
        deleteAPIKey(for: .gemini)
    }

    // MARK: - Migration

    /// Migrate from legacy single API key to per-provider storage
    /// This is safe to call multiple times
    func migrateFromLegacyGeminiKey() {
        // Check if we have a legacy key and no new-format Gemini key
        if let legacyKey = UserDefaults.standard.string(forKey: legacyAPIKeyKey),
           !legacyKey.isEmpty,
           getAPIKey(for: .gemini) == nil {

            // Migrate to new format
            _ = saveAPIKey(legacyKey, for: .gemini)

            // Set Gemini as selected provider if none selected
            if getSelectedProvider() == nil {
                saveSelectedProvider(.gemini)
            }

            // Delete legacy key
            UserDefaults.standard.removeObject(forKey: legacyAPIKeyKey)

            print("✅ Migrated legacy Gemini API key to new format")
        }
    }
}
