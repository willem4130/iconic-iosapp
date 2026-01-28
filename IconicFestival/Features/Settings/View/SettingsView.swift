import SwiftUI

/// Settings screen for Iconic Festival app
struct SettingsView: View {

    // MARK: - Properties

    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var router: Router
    @AppStorage("isNotificationsEnabled") private var notificationsEnabled = true

    // MARK: - Body

    var body: some View {
        List {
            festivalInfoSection
            appearanceSection
            notificationsSection
            aboutSection
            debugSection
        }
        .navigationTitle("More")
        .listStyle(.insetGrouped)
    }

    // MARK: - Sections

    private var festivalInfoSection: some View {
        Section {
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
                Label("Visit Website", systemImage: "safari")
            }

            Link(destination: URL(string: "mailto:\(FestivalInfo.contact.email)")!) {
                Label("Contact Us", systemImage: "envelope")
            }
        } header: {
            Text("Festival")
        }
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            Picker("Theme", selection: $themeManager.currentMode) {
                ForEach(ThemeMode.allCases) { mode in
                    Label(mode.displayName, systemImage: mode.icon)
                        .tag(mode)
                }
            }
            .pickerStyle(.navigationLink)
        }
    }

    private var notificationsSection: some View {
        Section("Notifications") {
            Toggle("Enable Notifications", isOn: $notificationsEnabled)

            NavigationLink {
                NotificationsSettingsView()
            } label: {
                Label("Notification Settings", systemImage: "bell.badge")
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            NavigationLink {
                AboutView()
            } label: {
                Label("About This App", systemImage: "info.circle")
            }

            LabeledContent("Version") {
                Text(appVersion)
            }

            LabeledContent("Build") {
                Text(buildNumber)
            }

            // Social links
            Link(destination: URL(string: "https://instagram.com/iconicfestival")!) {
                Label("Follow on Instagram", systemImage: "camera")
            }

            Link(destination: URL(string: "https://facebook.com/IconicFestivalNL")!) {
                Label("Follow on Facebook", systemImage: "hand.thumbsup")
            }
        }
    }

    @ViewBuilder
    private var debugSection: some View {
        #if DEBUG
        Section("Debug") {
            LabeledContent("Environment") {
                Text(AppEnvironment.current.name)
                    .foregroundStyle(.secondary)
            }

            Button("Clear All Data", role: .destructive) {
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

        Log.warning("All app data cleared")
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
