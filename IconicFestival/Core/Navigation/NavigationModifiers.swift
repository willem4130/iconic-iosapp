import SwiftUI

// MARK: - Sheet Modifier

/// View modifier for presenting sheets via Router
struct RouterSheetModifier: ViewModifier {
    @EnvironmentObject private var router: Router

    func body(content: Content) -> some View {
        content
            .sheet(item: $router.presentedSheet) { route in
                router.destination(for: route)
            }
    }
}

// MARK: - FullScreenCover Modifier

/// View modifier for presenting full screen covers via Router
struct RouterFullScreenModifier: ViewModifier {
    @EnvironmentObject private var router: Router

    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $router.presentedFullScreen) { route in
                router.destination(for: route)
            }
    }
}

// MARK: - View Extensions

extension View {

    /// Enables sheet presentation via Router
    func withRouterSheets() -> some View {
        modifier(RouterSheetModifier())
    }

    /// Enables full screen cover presentation via Router
    func withRouterFullScreenCovers() -> some View {
        modifier(RouterFullScreenModifier())
    }

    /// Enables both sheet and full screen cover presentation via Router
    func withRouterPresentation() -> some View {
        self
            .withRouterSheets()
            .withRouterFullScreenCovers()
    }
}

// MARK: - Route Identifiable Conformance

extension Route: Identifiable {
    var id: String {
        switch self {
        case .performanceDetail(let performance):
            return "performance-\(performance.id)"
        case .artistDetail(let artist):
            return "artist-\(artist.id)"
        case .faqDetail(let item):
            return "faq-\(item.id)"
        case .profile:
            return "profile"
        case .about:
            return "about"
        case .notifications:
            return "notifications"
        }
    }
}
