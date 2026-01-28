import SwiftUI

/// Root view that handles main navigation and tab structure
/// Iconic Festival 2026 - Main app navigation
struct RootView: View {

    // MARK: - Properties

    @EnvironmentObject private var router: Router
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedTab: AppTab = .timetable

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {
            TimetableView()
                .tabItem {
                    Label("Programma", systemImage: "calendar")
                }
                .tag(AppTab.timetable)

            InfoView()
                .tabItem {
                    Label("Info", systemImage: "info.circle")
                }
                .tag(AppTab.info)

            ChatView()
                .tabItem {
                    Label("Vraag", systemImage: "bubble.left.and.bubble.right")
                }
                .tag(AppTab.chat)

            NavigationStack(path: $router.settingsPath) {
                SettingsView()
                    .navigationDestination(for: Route.self) { route in
                        router.destination(for: route)
                    }
            }
            .tabItem {
                Label("Meer", systemImage: "ellipsis")
            }
            .tag(AppTab.settings)
        }
        .tint(AppColors.primaryGold)
    }
}

// MARK: - Tab Enum

enum AppTab: Hashable {
    case timetable
    case info
    case chat
    case settings
}

// MARK: - Preview

#Preview {
    RootView()
        .environmentObject(Router())
        .environmentObject(ThemeManager())
}
