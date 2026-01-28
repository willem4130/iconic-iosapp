import Foundation

// MARK: - Stage Enum

/// Festival podia
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
        case .theater: return "Openluchttheater gebied"
        }
    }
}

// MARK: - Artist Model

/// Artiest/band die optreedt op het festival
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

/// Een enkel optreden/set op het festival
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

/// Statische festival data voor Iconic 2026
enum FestivalData {

    // MARK: - Festival Info

    static let festivalName = "Iconic Festival 2026"
    static let festivalDate = "Zaterdag 9 mei 2026"
    static let festivalLocation = "Goffertpark, Nijmegen"
    static let festivalTagline = "Live Tribute To Your Favorite Bands"
    static let festivalDescription = """
    Iconic Festival is dé ultieme tribute festival ervaring! \
    Beleef een onvergetelijke dag vol muziek met de beste tributebands \
    die hits spelen van legendarische artiesten op twee geweldige podia.
    """

    // MARK: - Date Helpers

    /// Festival datum: Zaterdag 9 mei 2026
    static var festivalDateComponents: DateComponents {
        var components = DateComponents()
        components.year = 2026
        components.month = 5
        components.day = 9
        return components
    }

    // MARK: - Artists

    static let artists: [Artist] = [
        // Main Stage
        Artist(
            name: "Beach Boys' Best",
            tributeTo: "The Beach Boys",
            description: "Feel-good zomerse vibes met de beste Beach Boys hits",
            genre: "Surf Rock / Pop"
        ),
        Artist(
            name: "Coming on Strong",
            tributeTo: nil,
            description: "Energiek rock optreden",
            genre: "Rock"
        ),
        Artist(
            name: "The Cosmic Carnival",
            tributeTo: nil,
            description: "Een psychedelische reis door klassieke rock",
            genre: "Psychedelische Rock"
        ),
        Artist(
            name: "Treasure",
            tributeTo: "Bruno Mars",
            description: "De ultieme Bruno Mars tribute ervaring",
            genre: "Pop / R&B"
        ),
        Artist(
            name: "Donna's Hot Stuff",
            tributeTo: "Donna Summer",
            description: "Disco queen tribute - dans de nacht door",
            genre: "Disco"
        ),
        Artist(
            name: "Dirty Daddies",
            tributeTo: nil,
            description: "Festival headliners met explosieve energie",
            genre: "Rock / Party"
        ),

        // Theater Stage
        Artist(
            name: "ABBA GOLD Europe",
            tributeTo: "ABBA",
            description: "Europa's premier ABBA tribute - Dancing Queen wacht op je!",
            genre: "Pop / Disco"
        ),
        Artist(
            name: "Urban Solitude",
            tributeTo: "Anouk",
            description: "Krachtige vocalen als eerbetoon aan Nederlands rock-icoon Anouk",
            genre: "Rock / Pop"
        ),
        Artist(
            name: "Future Nostalgia",
            tributeTo: "Dua Lipa",
            description: "Moderne pophits en dance anthems",
            genre: "Pop / Dance"
        ),
        Artist(
            name: "The Dutch Queen",
            tributeTo: "Queen",
            description: "Legendarische Queen tribute - Bohemian Rhapsody, We Will Rock You, en meer!",
            genre: "Rock"
        )
    ]

    // MARK: - Timetable (Scenario #177 - Aanbevolen)

    /// Maakt het volledige programma voor het festival
    /// Gebruikt Scenario #177: Maximale overlap, beide volledige 75-min sets
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
            // Main Stage Programma (Vast)
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

            // Theater Podium Programma (Scenario #177)
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

    /// Optredens gegroepeerd per podium
    static func performancesByStage() -> [Stage: [Performance]] {
        let timetable = createTimetable()
        return Dictionary(grouping: timetable) { $0.stage }
    }

    /// Optredens gesorteerd op tijd
    static func performancesByTime() -> [Performance] {
        createTimetable().sorted { $0.startTime < $1.startTime }
    }
}
