import Foundation

// MARK: - Stage Enum

/// Festival stages
enum Stage: String, CaseIterable, Identifiable, Codable {
    case mainStage = "Main Stage"
    case theater = "Openluchttheater"

    var id: String { rawValue }

    var capacity: Int {
        switch self {
        case .mainStage: return 5000
        case .theater: return 2000
        }
    }

    var location: String {
        switch self {
        case .mainStage: return "Goffertpark"
        case .theater: return "Openluchttheater area"
        }
    }
}

// MARK: - Artist Model

/// Artist/band performing at the festival
struct Artist: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let tributeTo: String?
    let description: String
    let imageURL: String?
    let genre: String

    init(
        id: UUID = UUID(),
        name: String,
        tributeTo: String? = nil,
        description: String,
        imageURL: String? = nil,
        genre: String
    ) {
        self.id = id
        self.name = name
        self.tributeTo = tributeTo
        self.description = description
        self.imageURL = imageURL
        self.genre = genre
    }
}

// MARK: - Performance Model

/// A single performance/set at the festival
struct Performance: Identifiable, Codable, Hashable {
    let id: UUID
    let artist: Artist
    let stage: Stage
    let startTime: Date
    let endTime: Date
    let isHeadliner: Bool

    init(
        id: UUID = UUID(),
        artist: Artist,
        stage: Stage,
        startTime: Date,
        endTime: Date,
        isHeadliner: Bool = false
    ) {
        self.id = id
        self.artist = artist
        self.stage = stage
        self.startTime = startTime
        self.endTime = endTime
        self.isHeadliner = isHeadliner
    }

    var durationMinutes: Int {
        Int(endTime.timeIntervalSince(startTime) / 60)
    }

    var timeRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }
}

// MARK: - Festival Data

/// Static festival data for Iconic 2026
enum FestivalData {

    // MARK: - Festival Info

    static let festivalName = "Iconic Festival 2026"
    static let festivalDate = "Summer 2026"
    static let festivalLocation = "Goffertpark, Nijmegen"
    static let festivalDescription = """
    Iconic Festival is the ultimate tribute festival experience! \
    Join us for an unforgettable day of music featuring the best tribute bands \
    performing hits from legendary artists across two amazing stages.
    """

    // MARK: - Date Helpers

    /// Festival date (placeholder - adjust to actual date)
    static var festivalDateComponents: DateComponents {
        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 15 // Placeholder date
        return components
    }

    // MARK: - Artists

    static let artists: [Artist] = [
        // Main Stage
        Artist(
            name: "Beach Boys' Best",
            tributeTo: "The Beach Boys",
            description: "Feel-good summer vibes with the best Beach Boys hits",
            genre: "Surf Rock / Pop"
        ),
        Artist(
            name: "Coming on Strong",
            tributeTo: nil,
            description: "High-energy rock performance",
            genre: "Rock"
        ),
        Artist(
            name: "The Cosmic Carnival",
            tributeTo: nil,
            description: "A psychedelic journey through classic rock",
            genre: "Psychedelic Rock"
        ),
        Artist(
            name: "Treasure",
            tributeTo: "Bruno Mars",
            description: "The ultimate Bruno Mars tribute experience",
            genre: "Pop / R&B"
        ),
        Artist(
            name: "Donna's Hot Stuff",
            tributeTo: "Donna Summer",
            description: "Disco queen tribute - dance the night away",
            genre: "Disco"
        ),
        Artist(
            name: "Dirty Daddies",
            tributeTo: nil,
            description: "Festival headliners with explosive energy",
            genre: "Rock / Party"
        ),

        // Theater Stage
        Artist(
            name: "ABBA GOLD Europe",
            tributeTo: "ABBA",
            description: "Europe's premier ABBA tribute - Dancing Queen awaits!",
            genre: "Pop / Disco"
        ),
        Artist(
            name: "Urban Solitude",
            tributeTo: "Anouk",
            description: "Powerful vocals paying tribute to Dutch rock icon Anouk",
            genre: "Rock / Pop"
        ),
        Artist(
            name: "Future Nostalgia",
            tributeTo: "Dua Lipa",
            description: "Modern pop hits and dance anthems",
            genre: "Pop / Dance"
        ),
        Artist(
            name: "The Dutch Queen",
            tributeTo: "Queen",
            description: "Legendary Queen tribute - Bohemian Rhapsody, We Will Rock You, and more!",
            genre: "Rock"
        )
    ]

    // MARK: - Timetable (Scenario #177 - Recommended)

    /// Creates the full timetable for the festival
    /// Using Scenario #177: Maximum overlap, both full 75-min sets
    static func createTimetable() -> [Performance] {
        let calendar = Calendar.current
        var components = festivalDateComponents
        components.timeZone = TimeZone(identifier: "Europe/Amsterdam")

        func makeTime(hour: Int, minute: Int) -> Date {
            var timeComponents = components
            timeComponents.hour = hour
            timeComponents.minute = minute
            return calendar.date(from: timeComponents) ?? Date()
        }

        let artistsByName = Dictionary(uniqueKeysWithValues: artists.map { ($0.name, $0) })

        return [
            // Main Stage Schedule (Fixed)
            Performance(
                artist: artistsByName["Beach Boys' Best"]!,
                stage: .mainStage,
                startTime: makeTime(hour: 14, minute: 0),
                endTime: makeTime(hour: 15, minute: 0)
            ),
            Performance(
                artist: artistsByName["Coming on Strong"]!,
                stage: .mainStage,
                startTime: makeTime(hour: 15, minute: 15),
                endTime: makeTime(hour: 16, minute: 15)
            ),
            Performance(
                artist: artistsByName["The Cosmic Carnival"]!,
                stage: .mainStage,
                startTime: makeTime(hour: 16, minute: 45),
                endTime: makeTime(hour: 17, minute: 45)
            ),
            Performance(
                artist: artistsByName["Treasure"]!,
                stage: .mainStage,
                startTime: makeTime(hour: 18, minute: 30),
                endTime: makeTime(hour: 19, minute: 45)
            ),
            Performance(
                artist: artistsByName["Donna's Hot Stuff"]!,
                stage: .mainStage,
                startTime: makeTime(hour: 20, minute: 15),
                endTime: makeTime(hour: 21, minute: 30)
            ),
            Performance(
                artist: artistsByName["Dirty Daddies"]!,
                stage: .mainStage,
                startTime: makeTime(hour: 22, minute: 15),
                endTime: makeTime(hour: 23, minute: 30),
                isHeadliner: true
            ),

            // Theater Stage Schedule (Scenario #177)
            Performance(
                artist: artistsByName["ABBA GOLD Europe"]!,
                stage: .theater,
                startTime: makeTime(hour: 15, minute: 0),
                endTime: makeTime(hour: 16, minute: 15)
            ),
            Performance(
                artist: artistsByName["Urban Solitude"]!,
                stage: .theater,
                startTime: makeTime(hour: 17, minute: 0),
                endTime: makeTime(hour: 18, minute: 15)
            ),
            Performance(
                artist: artistsByName["Future Nostalgia"]!,
                stage: .theater,
                startTime: makeTime(hour: 19, minute: 0),
                endTime: makeTime(hour: 20, minute: 15)
            ),
            Performance(
                artist: artistsByName["The Dutch Queen"]!,
                stage: .theater,
                startTime: makeTime(hour: 21, minute: 0),
                endTime: makeTime(hour: 22, minute: 30),
                isHeadliner: true
            )
        ]
    }

    // MARK: - Grouped Performances

    /// Get performances grouped by stage
    static func performancesByStage() -> [Stage: [Performance]] {
        let timetable = createTimetable()
        return Dictionary(grouping: timetable) { $0.stage }
    }

    /// Get performances sorted by time
    static func performancesByTime() -> [Performance] {
        createTimetable().sorted { $0.startTime < $1.startTime }
    }
}
