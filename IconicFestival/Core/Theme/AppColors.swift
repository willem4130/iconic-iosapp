import SwiftUI

/// Iconic Festival brand colors
/// Primary White: #FFFFFF
/// Primary Dark: #08192C
/// Primary Gold: #F29100
enum AppColors {

    // MARK: - Brand Colors

    /// Primary white - #FFFFFF
    static let primaryWhite = Color.white

    /// Primary dark blue - #08192C
    static let primaryDark = Color(hex: "08192C")

    /// Primary gold/orange - #F29100
    static let primaryGold = Color(hex: "F29100")

    /// Warm cream background - #EFE9E4 (from website brand)
    static let warmCream = Color(hex: "EFE9E4")

    /// Warm cream darker variant for contrast
    static let warmCreamDark = Color(hex: "E5DDD6")

    // MARK: - Stage Colors

    /// Main Stage gold - #AA7712
    static let stageMain = Color(hex: "AA7712")

    /// Theater Stage coral - #E8927C
    static let stageTheater = Color(hex: "E8927C")

    // MARK: - Semantic Colors

    /// Success state color
    static let success = Color(hex: "22C55E")

    /// Warning state color
    static let warning = Color(hex: "F59E0B")

    /// Error/destructive state color
    static let error = Color(hex: "EF4444")

    /// Informational state color
    static let info = Color(hex: "3B82F6")

    // MARK: - Background Colors

    /// Primary background
    static var background: Color {
        Color(uiColor: .systemBackground)
    }

    /// Secondary/grouped background
    static var secondaryBackground: Color {
        Color(uiColor: .secondarySystemBackground)
    }

    /// Tertiary background
    static var tertiaryBackground: Color {
        Color(uiColor: .tertiarySystemBackground)
    }

    // MARK: - Text Colors

    /// Primary text color
    static var textPrimary: Color {
        Color(uiColor: .label)
    }

    /// Secondary text color
    static var textSecondary: Color {
        Color(uiColor: .secondaryLabel)
    }

    /// Tertiary text color
    static var textTertiary: Color {
        Color(uiColor: .tertiaryLabel)
    }

    /// Placeholder text color
    static var textPlaceholder: Color {
        Color(uiColor: .placeholderText)
    }

    // MARK: - Border & Separator

    /// Default separator color
    static var separator: Color {
        Color(uiColor: .separator)
    }

    /// Opaque separator color
    static var opaqueSeparator: Color {
        Color(uiColor: .opaqueSeparator)
    }

    // MARK: - Fill Colors

    /// Primary fill color
    static var fill: Color {
        Color(uiColor: .systemFill)
    }

    /// Secondary fill color
    static var secondaryFill: Color {
        Color(uiColor: .secondarySystemFill)
    }

    // MARK: - Gradients

    /// Iconic brand gradient (dark)
    static var brandGradient: LinearGradient {
        LinearGradient(
            colors: [primaryDark, primaryDark.opacity(0.85)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// Gold accent gradient
    static var goldGradient: LinearGradient {
        LinearGradient(
            colors: [primaryGold, primaryGold.opacity(0.8)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    /// Main Stage gradient
    static var mainStageGradient: LinearGradient {
        LinearGradient(
            colors: [stageMain, stageMain.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// Theater Stage gradient
    static var theaterStageGradient: LinearGradient {
        LinearGradient(
            colors: [stageTheater, stageTheater.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Color Extensions

extension Color {

    /// Initialize from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Animation Constants

/// Centralized animation configuration for consistent feel across the app
enum AppAnimations {
    // MARK: - Durations
    static let fast: Double = 0.15
    static let normal: Double = 0.25
    static let slow: Double = 0.4

    // MARK: - Standard Animations
    static let standard = Animation.easeInOut(duration: normal)
    static let quick = Animation.easeOut(duration: fast)
    static let gentle = Animation.easeInOut(duration: slow)

    // MARK: - Spring Animations
    static let spring = Animation.spring(response: 0.4, dampingFraction: 0.7)
    static let bouncy = Animation.spring(response: 0.35, dampingFraction: 0.6, blendDuration: 0.1)
    static let snappy = Animation.spring(response: 0.3, dampingFraction: 0.8)

    // MARK: - Entrance Animations
    static let cardEntrance = Animation.spring(response: 0.5, dampingFraction: 0.75)
    static let slideIn = Animation.spring(response: 0.4, dampingFraction: 0.8)

    // MARK: - Stagger Delay
    static func staggerDelay(index: Int, base: Double = 0.05) -> Double {
        return Double(index) * base
    }
}

// MARK: - Animated Appearance Modifier

/// Modifier for staggered entrance animations
struct AnimatedAppearance: ViewModifier {
    let delay: Double
    let animation: Animation

    @State private var isVisible = false

    init(delay: Double = 0, animation: Animation = AppAnimations.cardEntrance) {
        self.delay = delay
        self.animation = animation
    }

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(animation.delay(delay)) {
                    isVisible = true
                }
            }
    }
}

extension View {
    /// Applies a staggered entrance animation
    func animatedAppearance(delay: Double = 0, animation: Animation = AppAnimations.cardEntrance) -> some View {
        modifier(AnimatedAppearance(delay: delay, animation: animation))
    }

    /// Applies staggered entrance based on index
    func staggeredAppearance(index: Int, baseDelay: Double = 0.05) -> some View {
        modifier(AnimatedAppearance(
            delay: AppAnimations.staggerDelay(index: index, base: baseDelay),
            animation: AppAnimations.cardEntrance
        ))
    }
}

// MARK: - Card Tap Feedback

/// Visual feedback for tappable cards
struct CardTapFeedback: ViewModifier {
    @State private var isPressed = false
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .brightness(isPressed ? -0.02 : 0)
            .animation(AppAnimations.quick, value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in
                        isPressed = false
                        action()
                    }
            )
    }
}

extension View {
    func cardTapFeedback(action: @escaping () -> Void) -> some View {
        modifier(CardTapFeedback(action: action))
    }
}
