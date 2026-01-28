import SwiftUI

/// Instellingen scherm voor Iconic Festival app
struct SettingsView: View {

    // MARK: - Properties

    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var router: Router
    @AppStorage("isNotificationsEnabled") private var notificationsEnabled = true

    // MARK: - Body

    var body: some View {
        List {
            festivalInfoSection
            socialSection
            aiSection
            appearanceSection
            notificationsSection
            aboutSection
            debugSection
        }
        .navigationTitle("Meer")
        .listStyle(.insetGrouped)
    }

    // MARK: - Sections

    private var festivalInfoSection: some View {
        Section {
            // Logo
            HStack {
                Spacer()
                Image("IconicLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                Spacer()
            }
            .listRowBackground(AppColors.primaryDark)

            VStack(alignment: .leading, spacing: 8) {
                Text(FestivalData.festivalName)
                    .font(.headline)
                    .foregroundColor(AppColors.primaryGold)

                Text(FestivalData.festivalLocation)
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)

                Text(FestivalData.festivalDate)
                    .font(.caption)
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(.vertical, 4)

            Link(destination: URL(string: FestivalInfo.contact.website)!) {
                Label("Bezoek Website", systemImage: "safari")
            }

            Link(destination: URL(string: "mailto:\(FestivalInfo.contact.email)")!) {
                Label("Neem Contact Op", systemImage: "envelope")
            }
        } header: {
            Text("Festival")
        }
    }

    private var aiSection: some View {
        Section {
            NavigationLink {
                AISettingsView()
            } label: {
                HStack {
                    Label("AI Assistent", systemImage: "sparkles")
                    Spacer()
                    if ClaudeService.shared.isConfigured {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Text("Niet geconfigureerd")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        } header: {
            Text("Vraag AI")
        } footer: {
            Text("Configureer je Claude API key voor slimmere antwoorden in de chat.")
        }
    }

    private var appearanceSection: some View {
        Section("Weergave") {
            Picker("Thema", selection: $themeManager.currentMode) {
                ForEach(ThemeMode.allCases) { mode in
                    Label(mode.displayName, systemImage: mode.icon)
                        .tag(mode)
                }
            }
            .pickerStyle(.navigationLink)
        }
    }

    private var notificationsSection: some View {
        Section("Meldingen") {
            Toggle("Meldingen Inschakelen", isOn: $notificationsEnabled)

            NavigationLink {
                NotificationsSettingsView()
            } label: {
                Label("Meldinginstellingen", systemImage: "bell.badge")
            }
        }
    }

    private var aboutSection: some View {
        Section("Over") {
            NavigationLink {
                AboutView()
            } label: {
                Label("Over Deze App", systemImage: "info.circle")
            }

            LabeledContent("Versie") {
                Text(appVersion)
            }

            LabeledContent("Build") {
                Text(buildNumber)
            }

        }
    }

    private var socialSection: some View {
        Section {
            HStack(spacing: 20) {
                Spacer()

                Link(destination: URL(string: FestivalInfo.contact.instagramURL)!) {
                    VStack(spacing: 4) {
                        Image(systemName: "camera.fill")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryGold)
                        Text("Instagram")
                            .font(.caption2)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }

                Link(destination: URL(string: FestivalInfo.contact.facebookURL)!) {
                    VStack(spacing: 4) {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryGold)
                        Text("Facebook")
                            .font(.caption2)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }

                Link(destination: URL(string: FestivalInfo.contact.website)!) {
                    VStack(spacing: 4) {
                        Image(systemName: "globe")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryGold)
                        Text("Website")
                            .font(.caption2)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }

                Spacer()
            }
            .padding(.vertical, 8)
        } header: {
            Text("Volg Ons")
        } footer: {
            Text("Blijf op de hoogte van het laatste nieuws!")
        }
    }

    @ViewBuilder
    private var debugSection: some View {
        #if DEBUG
        Section("Debug") {
            LabeledContent("Omgeving") {
                Text(AppEnvironment.current.name)
                    .foregroundStyle(.secondary)
            }

            Button("Alle Data Wissen", role: .destructive) {
                clearAllData()
            }
        }
        #endif
    }

    // MARK: - Helpers

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    private func clearAllData() {
        // Clear UserDefaults
        UserDefaultsManager().clearAll()

        // Clear Keychain
        try? KeychainManager().deleteAll()

        Log.warning("Alle app data gewist")
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environmentObject(ThemeManager())
    .environmentObject(Router())
}
