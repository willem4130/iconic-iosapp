import SwiftUI

/// Centralized navigation router using NavigationStack
/// Manages all navigation paths and provides type-safe routing
@MainActor
final class Router: ObservableObject {

    // MARK: - Navigation Paths

    /// Navigation path for Timetable tab
    @Published var timetablePath = NavigationPath()

    /// Navigation path for Info tab
    @Published var infoPath = NavigationPath()

    /// Navigation path for Settings tab
    @Published var settingsPath = NavigationPath()

    // MARK: - Sheet & FullScreenCover State

    @Published var presentedSheet: Route?
    @Published var presentedFullScreen: Route?

    // MARK: - Navigation Methods

    /// Push a route onto the current navigation stack
    func push(_ route: Route, on tab: AppTab = .timetable) {
        switch tab {
        case .timetable:
            timetablePath.append(route)
        case .info:
            infoPath.append(route)
        case .chat:
            break // Chat doesn't use navigation stack
        case .settings:
            settingsPath.append(route)
        }
    }

    /// Pop the top view from the current navigation stack
    func pop(on tab: AppTab = .timetable) {
        switch tab {
        case .timetable:
            guard !timetablePath.isEmpty else { return }
            timetablePath.removeLast()
        case .info:
            guard !infoPath.isEmpty else { return }
            infoPath.removeLast()
        case .chat:
            break
        case .settings:
            guard !settingsPath.isEmpty else { return }
            settingsPath.removeLast()
        }
    }

    /// Pop to root of the current navigation stack
    func popToRoot(on tab: AppTab = .timetable) {
        switch tab {
        case .timetable:
            timetablePath = NavigationPath()
        case .info:
            infoPath = NavigationPath()
        case .chat:
            break
        case .settings:
            settingsPath = NavigationPath()
        }
    }

    /// Present a sheet
    func presentSheet(_ route: Route) {
        presentedSheet = route
    }

    /// Dismiss the current sheet
    func dismissSheet() {
        presentedSheet = nil
    }

    /// Present a full screen cover
    func presentFullScreen(_ route: Route) {
        presentedFullScreen = route
    }

    /// Dismiss the current full screen cover
    func dismissFullScreen() {
        presentedFullScreen = nil
    }

    // MARK: - Destination Builder

    /// Returns the destination view for a given route
    @ViewBuilder
    func destination(for route: Route) -> some View {
        switch route {
        case .performanceDetail(let performance):
            PerformanceDetailSheet(performance: performance)
        case .artistDetail(let artist):
            ArtistDetailView(artist: artist)
        case .faqDetail(let item):
            FAQDetailView(item: item)
        case .profile:
            ProfileView()
        case .about:
            AboutView()
        case .notifications:
            NotificationsSettingsView()
        }
    }
}

// MARK: - Placeholder Views

struct ArtistDetailView: View {
    let artist: Artist

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(artist.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                if let tribute = artist.tributeTo {
                    Text("Tribute to \(tribute)")
                        .font(.headline)
                        .foregroundColor(AppColors.primaryGold)
                }

                Text(artist.description)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle(artist.name)
    }
}

struct FAQDetailView: View {
    let item: FAQItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(item.question)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(item.answer)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("FAQ")
    }
}

struct NotificationsSettingsView: View {
    @AppStorage("notifyBeforePerformance") private var notifyBefore = true
    @AppStorage("notifyFavoriteArtists") private var notifyFavorites = true

    var body: some View {
        List {
            Section("Herinneringen") {
                Toggle("Herinnering voor optredens", isOn: $notifyBefore)
                Toggle("Alleen voor favoriete artiesten", isOn: $notifyFavorites)
            }

            Section(footer: Text("Meldingen helpen je om nooit je favoriete acts te missen!")) {
                EmptyView()
            }
        }
        .navigationTitle("Meldingen")
    }
}
