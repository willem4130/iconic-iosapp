import SwiftUI

/// Instellingen voor de AI chat assistent
struct AISettingsView: View {

    // MARK: - Properties

    @StateObject private var claudeService = ClaudeService.shared
    @State private var apiKey = ""
    @State private var isShowingKey = false
    @State private var showingSaveAlert = false
    @State private var showingDeleteAlert = false
    @State private var alertMessage = ""

    // MARK: - Body

    var body: some View {
        List {
            statusSection
            apiKeySection
            infoSection
        }
        .navigationTitle("AI Instellingen")
        .listStyle(.insetGrouped)
        .alert("API Key", isPresented: $showingSaveAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .alert("API Key Verwijderen", isPresented: $showingDeleteAlert) {
            Button("Annuleren", role: .cancel) {}
            Button("Verwijderen", role: .destructive) {
                deleteAPIKey()
            }
        } message: {
            Text("Weet je zeker dat je de API key wilt verwijderen? De AI chat zal terugvallen op basis-antwoorden.")
        }
    }

    // MARK: - Sections

    private var statusSection: some View {
        Section {
            HStack {
                Image(systemName: claudeService.isConfigured ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(claudeService.isConfigured ? .green : .red)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 4) {
                    Text(claudeService.isConfigured ? "AI Actief" : "AI Niet Geconfigureerd")
                        .font(.headline)

                    Text(claudeService.isConfigured
                         ? "De chat gebruikt Claude AI voor slimme antwoorden."
                         : "Voeg een API key toe om AI-antwoorden in te schakelen.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
    }

    private var apiKeySection: some View {
        Section {
            if claudeService.isConfigured {
                // Key is configured
                HStack {
                    Image(systemName: "key.fill")
                        .foregroundColor(AppColors.primaryGold)

                    if isShowingKey {
                        Text(apiKey.isEmpty ? "••••••••••••" : apiKey)
                            .font(.system(.body, design: .monospaced))
                    } else {
                        Text("••••••••••••••••••••")
                            .font(.system(.body, design: .monospaced))
                    }

                    Spacer()

                    Button {
                        isShowingKey.toggle()
                    } label: {
                        Image(systemName: isShowingKey ? "eye.slash" : "eye")
                    }
                }

                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Label("API Key Verwijderen", systemImage: "trash")
                }
            } else {
                // Key not configured
                VStack(alignment: .leading, spacing: 12) {
                    Text("Claude API Key")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    SecureField("sk-ant-...", text: $apiKey)
                        .textContentType(.password)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .font(.system(.body, design: .monospaced))

                    Button {
                        saveAPIKey()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Opslaan", systemImage: "checkmark.circle")
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(apiKey.isEmpty || !apiKey.hasPrefix("sk-"))
                }
                .padding(.vertical, 8)
            }
        } header: {
            Text("API Key")
        } footer: {
            if !claudeService.isConfigured {
                Text("Je API key wordt veilig opgeslagen in de iOS Keychain en verlaat nooit je apparaat.")
            }
        }
    }

    private var infoSection: some View {
        Section {
            Link(destination: URL(string: "https://console.anthropic.com/")!) {
                Label("Krijg een API Key", systemImage: "arrow.up.right.square")
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Hoe het werkt")
                    .font(.headline)

                Text("""
                1. Maak een account aan op console.anthropic.com
                2. Genereer een API key
                3. Plak de key hierboven
                4. De chat gebruikt nu Claude AI!
                """)
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)

            VStack(alignment: .leading, spacing: 8) {
                Text("Kosten")
                    .font(.headline)

                Text("Claude Haiku kost ongeveer €0.01 per vraag. Anthropic biedt gratis credits voor nieuwe accounts.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        } header: {
            Text("Informatie")
        }
    }

    // MARK: - Actions

    private func saveAPIKey() {
        guard !apiKey.isEmpty else { return }

        do {
            try claudeService.setAPIKey(apiKey)
            alertMessage = "API key succesvol opgeslagen!"
            showingSaveAlert = true
            Log.info("Claude API key opgeslagen")
        } catch {
            alertMessage = "Fout bij opslaan: \(error.localizedDescription)"
            showingSaveAlert = true
            Log.error("Fout bij opslaan API key: \(error)")
        }
    }

    private func deleteAPIKey() {
        do {
            try claudeService.clearAPIKey()
            apiKey = ""
            Log.info("Claude API key verwijderd")
        } catch {
            alertMessage = "Fout bij verwijderen: \(error.localizedDescription)"
            showingSaveAlert = true
            Log.error("Fout bij verwijderen API key: \(error)")
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AISettingsView()
    }
}
