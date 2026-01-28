import SwiftUI

/// Root view that handles main navigation and tab structure
/// Iconic Festival 2026 - Main app navigation
struct RootView: View {

    // MARK: - Properties

    @EnvironmentObject private var router: Router
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedTab: Tab = .timetable

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {
            timetableTab
            infoTab
            chatTab
            settingsTab
        }
        .tint(AppColors.primaryGold)
    }

    // MARK: - Tabs

    private var timetableTab: some View {
        TimetableView()
            .tabItem {
                Label("Timetable", systemImage: "calendar")
            }
            .tag(Tab.timetable)
    }

    private var infoTab: some View {
        InfoView()
            .tabItem {
                Label("Info", systemImage: "info.circle")
            }
            .tag(Tab.info)
    }

    private var chatTab: some View {
        ChatView()
            .tabItem {
                Label("Ask", systemImage: "bubble.left.and.bubble.right")
            }
            .tag(Tab.chat)
    }

    private var settingsTab: some View {
        NavigationStack(path: $router.settingsPath) {
            SettingsView()
                .navigationDestination(for: Route.self) { route in
                    router.destination(for: route)
                }
        }
        .tabItem {
            Label("More", systemImage: "ellipsis")
        }
        .tag(Tab.settings)
    }
}

// MARK: - Tab Enum

enum Tab: Hashable {
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
