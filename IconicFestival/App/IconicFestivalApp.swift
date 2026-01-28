import SwiftUI
import SwiftData

/// Iconic Festival 2026 - Official Festival App
/// Main entry point for the application
@main
struct IconicFestivalApp: App {

    // MARK: - Properties

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var router = Router()
    @StateObject private var themeManager = ThemeManager()

    /// SwiftData model container for persistence
    private let modelContainer: ModelContainer

    // MARK: - Initialization

    init() {
        // Initialize SwiftData container
        do {
            let schema = Schema([
                FavoriteArtist.self,
                ChatMessage.self
            ])
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .none
            )
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }

        // Configure dependencies
        DependencyContainer.shared.register()

        // Log app launch
        Log.info("Iconic Festival App launched - Environment: \(AppEnvironment.current.name)")
    }

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
                .modelContainer(modelContainer)
                .onAppear {
                    configureAppearance()
                }
        }
    }

    // MARK: - Private Methods

    private func configureAppearance() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColors.primaryDark)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(AppColors.primaryGold)

        // Configure tab bar appearance
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor(AppColors.primaryDark)

        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        UITabBar.appearance().tintColor = UIColor(AppColors.primaryGold)
    }
}
