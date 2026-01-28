import Foundation

/// Defines all navigable routes in the application
/// Conform to Hashable for NavigationStack compatibility
enum Route: Hashable {

    // MARK: - Festival Routes

    /// Detail view for a specific performance
    case performanceDetail(performance: Performance)

    /// Artist detail view
    case artistDetail(artist: Artist)

    /// FAQ item detail
    case faqDetail(item: FAQItem)

    // MARK: - Settings Routes

    /// User profile view
    case profile

    /// About/Info view
    case about

    /// Notifications settings
    case notifications
}

// MARK: - Route Metadata

extension Route {

    /// Navigation title for each route
    var title: String {
        switch self {
        case .performanceDetail:
            return "Performance"
        case .artistDetail:
            return "Artist"
        case .faqDetail:
            return "FAQ"
        case .profile:
            return "Profile"
        case .about:
            return "About"
        case .notifications:
            return "Notifications"
        }
    }

    /// System image name for each route
    var systemImage: String? {
        switch self {
        case .performanceDetail:
            return "music.note"
        case .artistDetail:
            return "person.fill"
        case .faqDetail:
            return "questionmark.circle"
        case .profile:
            return "person.circle"
        case .about:
            return "info.circle"
        case .notifications:
            return "bell.fill"
        }
    }
}
