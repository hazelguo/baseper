import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: TranscriptionViewModel
    @Environment(\.dismiss) var dismiss

    // Unified model list: (provider, model) tuples
    @State private var allModels: [(provider: ProviderID, model: TranscriptionModel)] = []
    @State private var selectedProviderID: ProviderID
    @State private var selectedModelID: String?

    // Per-provider API keys
    @State private var geminiAPIKey: String = ""
    @State private var groqAPIKey: String = ""

    // Validation state
    @State private var validationStatus: ValidationStatus = .none
    @State private var isValidating = false
    @State private var isSaving = false

    init(viewModel: TranscriptionViewModel) {
        self.viewModel = viewModel
        _selectedProviderID = State(initialValue: viewModel.providerManager.selectedProviderID)
        _selectedModelID = State(initialValue: viewModel.providerManager.selectedModelID)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header with close button
            HStack {
                Text("Settings")
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .keyboardShortcut(.cancelAction)
            }

            ScrollView {
                VStack(spacing: 24) {
                    // Unified Model Selection
                    modelSelectionSection

                    Divider()

                    // API Key Section
                    apiKeySection

                    // Security info
                    securityInfo
                }
            }

            Spacer()

            // Save button — full-width pill
            Button(action: { saveSettings() }) {
                Text("Save")
                    .font(.system(size: 13, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(Capsule())
            .keyboardShortcut(.defaultAction)
            .disabled(isSaving || !hasValidInput)
        }
        .padding(24)
        .frame(width: 550, height: 560)
        .onAppear {
            loadSettings()
        }
    }

    // MARK: - Unified Model Selection

    private var modelSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Model")
                .font(.headline)

            if allModels.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                VStack(spacing: 8) {
                    ForEach(allModels, id: \.model.id) { entry in
                        ModelRow(
                            model: entry.model,
                            providerName: entry.provider.displayName,
                            isCheapest: entry.model.id == cheapestModelID,
                            isSelected: selectedModelID == entry.model.id,
                            onSelect: {
                                selectedModelID = entry.model.id
                                selectedProviderID = entry.provider
                                validationStatus = .none
                            }
                        )
                    }
                }
            }
        }
    }

    // MARK: - API Key Section

    private var apiKeySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(selectedProviderID.displayName) API Key")
                    .font(.headline)

                Spacer()

                // Validate button
                Button(action: { validateAPIKey() }) {
                    HStack(spacing: 4) {
                        if isValidating {
                            ProgressView()
                                .scaleEffect(0.7)
                        } else {
                            Text("Validate")
                                .font(.caption)
                        }
                    }
                }
                .buttonStyle(.bordered)
                .disabled(currentAPIKey.isEmpty || isValidating)
            }

            // API key input
            SecureField("Enter your API key", text: currentAPIKeyBinding)
                .textFieldStyle(.roundedBorder)
                .cornerRadius(8)

            // Validation status
            if validationStatus != .none {
                HStack(spacing: 6) {
                    Image(systemName: validationStatus.icon)
                        .font(.caption)
                    Text(validationStatus.message)
                        .font(.caption)
                }
                .foregroundColor(validationStatus.color)
            }

            // Help link
            providerHelpLink
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var securityInfo: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.shield.fill")
                .font(.caption2)
                .foregroundColor(.blue)
            Text("Your API key is stored locally on your Mac and never leaves your device")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Helper Views

    private var providerHelpLink: some View {
        Group {
            switch selectedProviderID {
            case .gemini:
                Link("Get your free API key at Google AI Studio →",
                     destination: URL(string: selectedProviderID.apiKeyURL)!)
            case .groq:
                Link("Get your free API key at Groq Console →",
                     destination: URL(string: selectedProviderID.apiKeyURL)!)
            }
        }
    }

    // MARK: - Computed Properties

    private var currentAPIKeyBinding: Binding<String> {
        switch selectedProviderID {
        case .gemini:
            return $geminiAPIKey
        case .groq:
            return $groqAPIKey
        }
    }

    private var currentAPIKey: String {
        switch selectedProviderID {
        case .gemini:
            return geminiAPIKey
        case .groq:
            return groqAPIKey
        }
    }

    private var hasValidInput: Bool {
        return !currentAPIKey.isEmpty && selectedModelID != nil
    }

    private var cheapestModelID: String? {
        allModels.min(by: { $0.model.costPerHour < $1.model.costPerHour })?.model.id
    }

    // MARK: - Actions

    private func loadSettings() {
        // Load API keys for all providers
        geminiAPIKey = KeychainManager.shared.getAPIKey(for: .gemini) ?? ""
        groqAPIKey = KeychainManager.shared.getAPIKey(for: .groq) ?? ""

        // Load current provider and model
        selectedProviderID = viewModel.providerManager.selectedProviderID
        selectedModelID = viewModel.providerManager.selectedModelID

        // Load models from ALL providers
        Task {
            await loadAllModels()
        }
    }

    private func loadAllModels() async {
        var models: [(provider: ProviderID, model: TranscriptionModel)] = []

        for providerID in ProviderID.allCases {
            let providerModels = await viewModel.providerManager.getAvailableModels(for: providerID)
            for model in providerModels {
                models.append((provider: providerID, model: model))
            }
        }

        // Sort by cost (cheapest first)
        models.sort { $0.model.costPerHour < $1.model.costPerHour }

        allModels = models

        // If no model selected or current model not in list, select first
        if selectedModelID == nil || !models.contains(where: { $0.model.id == selectedModelID }) {
            if let first = models.first {
                selectedModelID = first.model.id
                selectedProviderID = first.provider
            }
        }
    }

    private func validateAPIKey() {
        guard !currentAPIKey.isEmpty else { return }

        isValidating = true
        validationStatus = .validating

        Task {
            do {
                let provider: any TranscriptionProvider
                switch selectedProviderID {
                case .gemini:
                    provider = GeminiService()
                case .groq:
                    provider = GroqService()
                }

                await provider.setAPIKey(currentAPIKey)
                if let modelID = selectedModelID {
                    await provider.setModel(modelID)
                }

                _ = try await provider.validateAPIKey()

                await MainActor.run {
                    validationStatus = .valid
                    isValidating = false
                }
            } catch {
                await MainActor.run {
                    validationStatus = .invalid(error.localizedDescription)
                    isValidating = false
                }
            }
        }
    }

    private func saveSettings() {
        isSaving = true

        // Save API keys for all providers
        if !geminiAPIKey.isEmpty {
            _ = KeychainManager.shared.saveAPIKey(geminiAPIKey, for: .gemini)
        }
        if !groqAPIKey.isEmpty {
            _ = KeychainManager.shared.saveAPIKey(groqAPIKey, for: .groq)
        }

        // Save provider and model selection
        Task {
            if let modelID = selectedModelID {
                await viewModel.providerManager.setProvider(selectedProviderID, modelID: modelID)
            }
            viewModel.updateAPIKey()

            await MainActor.run {
                isSaving = false
                dismiss()
            }
        }
    }
}

// MARK: - Model Row Component

struct ModelRow: View {
    let model: TranscriptionModel
    let providerName: String
    let isCheapest: Bool
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(providerName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("·")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(model.displayName)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }

                    HStack(spacing: 8) {
                        Text(model.formattedCost)
                            .font(.caption)
                            .foregroundColor(.secondary)

                        if let info = model.secondaryInfo {
                            Text("·")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(info)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        if isCheapest {
                            Text("Cheapest")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.green)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.15))
                                .cornerRadius(4)
                        }
                    }
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 16))
                }
            }
            .padding(12)
            .background(isSelected ? Color.accentColor.opacity(0.1) : Color.secondary.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Validation Status

enum ValidationStatus: Equatable {
    case none
    case validating
    case valid
    case invalid(String)

    var icon: String {
        switch self {
        case .none:
            return ""
        case .validating:
            return "circle.dotted"
        case .valid:
            return "checkmark.circle.fill"
        case .invalid:
            return "xmark.circle.fill"
        }
    }

    var message: String {
        switch self {
        case .none:
            return ""
        case .validating:
            return "Validating..."
        case .valid:
            return "API key is valid"
        case .invalid(let error):
            return "Invalid: \(error)"
        }
    }

    var color: Color {
        switch self {
        case .none, .validating:
            return .secondary
        case .valid:
            return .green
        case .invalid:
            return .red
        }
    }
}
