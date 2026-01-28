import Foundation

/// ViewModel for the AI chat assistant
@MainActor
@Observable
final class ChatViewModel {

    // MARK: - Properties

    var isLoading = false
    var error: Error?

    let suggestions = [
        "When does The Dutch Queen play?",
        "What food is available?",
        "Where can I park?",
        "What time do gates open?"
    ]

    // MARK: - Festival Context

    /// Build context about the festival for AI responses
    private var festivalContext: String {
        let performances = FestivalData.performancesByTime()
        let timetableInfo = performances.map { perf in
            "\(perf.artist.name) plays at \(perf.stage.rawValue) from \(timeString(perf.startTime)) to \(timeString(perf.endTime))"
        }.joined(separator: "\n")

        return """
        ICONIC FESTIVAL 2026 INFORMATION:

        Festival: \(FestivalData.festivalName)
        Location: \(FestivalData.festivalLocation)

        TIMETABLE:
        \(timetableInfo)

        VENUE:
        - Main Stage: 5000 capacity, Goffertpark
        - Openluchttheater: 2000 capacity, separate area

        OPENING HOURS:
        \(FestivalInfo.openingHours)

        PARKING:
        \(FestivalInfo.parkingInfo)

        PUBLIC TRANSPORT:
        \(FestivalInfo.publicTransportInfo)

        CONTACT:
        - Email: \(FestivalInfo.contact.email)
        - Phone: \(FestivalInfo.contact.phone)
        - Website: \(FestivalInfo.contact.website)
        - Emergency: \(FestivalInfo.contact.emergencyPhone)
        """
    }

    // MARK: - Response Generation

    /// Get AI response for user query
    /// In production, this would call the Claude API
    /// For now, uses local pattern matching for demo
    func getResponse(for query: String) async -> String {
        isLoading = true
        defer { isLoading = false }

        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)

        let lowercasedQuery = query.lowercased()

        // Pattern matching for common queries
        // In production, replace with actual Claude API call

        // Timetable queries
        if lowercasedQuery.contains("when") || lowercasedQuery.contains("time") || lowercasedQuery.contains("play") {
            return handleTimetableQuery(lowercasedQuery)
        }

        // Food queries
        if lowercasedQuery.contains("food") || lowercasedQuery.contains("eat") || lowercasedQuery.contains("drink") {
            return """
            We have a wide variety of food vendors at Iconic Festival! 🍕🍔

            Available options include:
            • Dutch classics (bitterballen, frikandellen)
            • Asian cuisine (wok, sushi)
            • Mexican (tacos, burritos)
            • Italian (pizza, pasta)
            • BBQ & grilled meats
            • Vegetarian & vegan options

            There are also free water taps throughout the festival. We use a token/cashless payment system - you can top up at multiple points or pay by card at most vendors.
            """
        }

        // Parking queries
        if lowercasedQuery.contains("park") || lowercasedQuery.contains("car") {
            return """
            Parking options at Iconic Festival:

            🅿️ P1 Goffertpark (main parking) - €15/day
            🅿️ P2 Winkelcentrum Dukenburg - €10/day with free shuttle

            We recommend using public transport or coming by bike! Free guarded bike parking is available at the entrance.
            """
        }

        // Opening/gates queries
        if lowercasedQuery.contains("gate") || lowercasedQuery.contains("open") || lowercasedQuery.contains("start") {
            return """
            Opening times for Iconic Festival 2026:

            🚪 Gates open: 13:00
            🎵 First act: 14:00 (Beach Boys' Best on Main Stage)
            🌙 Last act ends: 23:30
            🏁 Festival closes: 00:30

            We recommend arriving early to explore and find a good spot!
            """
        }

        // Ticket queries
        if lowercasedQuery.contains("ticket") {
            return """
            Tickets for Iconic Festival:

            🎫 Buy tickets at iconicfestival.nl or through Weeztix
            🔄 Tickets are transferable via our website
            ❌ No refunds, but you can resell through our official platform
            ⭐ VIP tickets include: fast-track entry, exclusive viewing area, private bar, VIP lounge, and welcome drink

            Buy early - we often sell out!
            """
        }

        // Stage queries
        if lowercasedQuery.contains("stage") {
            return """
            Iconic Festival has two amazing stages:

            🎸 MAIN STAGE
            • Location: Goffertpark
            • Capacity: 5000
            • Acts: Beach Boys' Best, Coming on Strong, The Cosmic Carnival, Treasure, Donna's Hot Stuff, Dirty Daddies (headliner)

            🎭 OPENLUCHTTHEATER
            • Location: Separate theater area
            • Capacity: 2000
            • Acts: ABBA GOLD Europe, Urban Solitude (Anouk tribute), Future Nostalgia (Dua Lipa tribute), The Dutch Queen (Queen tribute - headliner)
            """
        }

        // Artist queries
        for artist in FestivalData.artists {
            if lowercasedQuery.contains(artist.name.lowercased()) ||
               (artist.tributeTo != nil && lowercasedQuery.contains(artist.tributeTo!.lowercased())) {
                if let performance = FestivalData.createTimetable().first(where: { $0.artist.name == artist.name }) {
                    let tribute = artist.tributeTo != nil ? " (Tribute to \(artist.tributeTo!))" : ""
                    return """
                    🎤 \(artist.name)\(tribute)

                    📍 Stage: \(performance.stage.rawValue)
                    ⏰ Time: \(performance.timeRange)
                    ⏱️ Duration: \(performance.durationMinutes) minutes
                    🎵 Genre: \(artist.genre)
                    \(performance.isHeadliner ? "⭐ HEADLINER" : "")

                    \(artist.description)
                    """
                }
            }
        }

        // Default response
        return """
        Thanks for your question! Here's some general info about Iconic Festival 2026:

        📍 Location: Goffertpark, Nijmegen
        📅 Opens: 13:00
        🎵 Music: 14:00 - 23:30
        🎸 Two stages with amazing tribute bands

        Feel free to ask me about:
        • Specific bands and their set times
        • Food and drinks
        • Parking and transport
        • Tickets and VIP
        • Facilities and accessibility

        What would you like to know?
        """
    }

    // MARK: - Timetable Query Handler

    private func handleTimetableQuery(_ query: String) -> String {
        // Check for specific artist mentions
        for artist in FestivalData.artists {
            if query.contains(artist.name.lowercased()) ||
               (artist.tributeTo != nil && query.contains(artist.tributeTo!.lowercased())) {
                if let performance = FestivalData.createTimetable().first(where: { $0.artist.name == artist.name }) {
                    return "🎤 \(artist.name) plays at the \(performance.stage.rawValue) from \(performance.timeRange)!"
                }
            }
        }

        // General timetable
        let mainStage = FestivalData.performancesByStage()[.mainStage]?.sorted { $0.startTime < $1.startTime } ?? []
        let theater = FestivalData.performancesByStage()[.theater]?.sorted { $0.startTime < $1.startTime } ?? []

        let mainSchedule = mainStage.map { "\(timeString($0.startTime)) - \($0.artist.name)" }.joined(separator: "\n")
        let theaterSchedule = theater.map { "\(timeString($0.startTime)) - \($0.artist.name)" }.joined(separator: "\n")

        return """
        📋 ICONIC FESTIVAL 2026 TIMETABLE

        🎸 MAIN STAGE:
        \(mainSchedule)

        🎭 OPENLUCHTTHEATER:
        \(theaterSchedule)

        Ask me about any specific artist for more details!
        """
    }

    // MARK: - Helpers

    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
