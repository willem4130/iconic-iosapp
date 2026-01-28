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

// MARK: - Artist Socials

/// Social media links voor een artiest
struct ArtistSocials: Codable, Hashable {
    let website: String?
    let instagram: String?
    let facebook: String?
    let spotify: String?
    let youtube: String?

    init(
        website: String? = nil,
        instagram: String? = nil,
        facebook: String? = nil,
        spotify: String? = nil,
        youtube: String? = nil
    ) {
        self.website = website
        self.instagram = instagram
        self.facebook = facebook
        self.spotify = spotify
        self.youtube = youtube
    }

    /// Heeft minstens één social link
    var hasAny: Bool {
        [website, instagram, facebook, spotify, youtube].contains { $0 != nil }
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
    let socials: ArtistSocials

    init(
        id: UUID = UUID(),
        name: String,
        tributeTo: String? = nil,
        description: String,
        imageURL: String? = nil,
        genre: String,
        socials: ArtistSocials = ArtistSocials()
    ) {
        self.id = id
        self.name = name
        self.tributeTo = tributeTo
        self.description = description
        self.imageURL = imageURL
        self.genre = genre
        self.socials = socials
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
            description: """
            Winnaar van seizoen 5 van The Tribute – Battle of the Bands! Beach Boys' Best brengt \
            de perfecte harmonieën, aanstekelijke energie en ongeëvenaard vakmanschap van The Beach Boys \
            tot leven. Hun liveshow draait om meerstemmige vocale arrangementen van klassiekers als \
            "Good Vibrations", "California Girls" en "God Only Knows", met volop ruimte voor \
            meezingers. Zomerse vibes gegarandeerd!
            """,
            imageURL: "https://iconicfestival.nl/wp-content/uploads/2025/11/BeachBoys_Best1_creditsWilliamRutte-min-scaled.jpg",
            genre: "Surf Rock / Pop",
            socials: ArtistSocials(
                website: "https://www.beachboysbest.nl/",
                instagram: "https://www.instagram.com/beachboysbest/",
                facebook: "https://www.facebook.com/beachboysbest/"
            )
        ),
        Artist(
            name: "Coming on Strong",
            tributeTo: "Golden Earring",
            description: """
            Vijf ervaren muzikanten uit Den Haag met authentieke muziekpassie en diepe banden met \
            Golden Earring – ze werkten eerder samen met de originele bandleden. Coming on Strong \
            bereikte de finale van The Tribute – Battle of the Bands seizoen 5 en speelde vier keer \
            in een uitverkochte Ziggo Dome tijdens The Tribute Live in Concert. Hun repertoire \
            omvat energieke rockhits tot minder bekende nummers, altijd met focus op authenticiteit. \
            Eerder te zien op Zwarte Cross, Paaspop, Bevrijdingsfestival Den Haag en Oerol.
            """,
            imageURL: "https://iconicfestival.nl/wp-content/uploads/2024/01/Battle-of-The-Bands-The-Tribute-1-Credits-William-Rutten-min-scaled.jpg",
            genre: "Rock",
            socials: ArtistSocials(
                website: "https://comingonstrong.nl/",
                instagram: "https://www.instagram.com/comingonstrong.nl/",
                facebook: "https://www.facebook.com/comingonstrongnl"
            )
        ),
        Artist(
            name: "The Cosmic Carnival",
            tributeTo: "Fleetwood Mac",
            description: """
            The Cosmic Carnival neemt je mee op een muzikale ontdekkingsreis door het wonderlijke \
            universum van Fleetwood Mac. De band verkent het uitgebreide oeuvre voorbij de bekendste \
            hits, met meeslepende verhalen vol spanning, romantiek en intriges. Ze spelen met \
            overtuiging en recht vanuit het hart – van intiem en delicaat tot groots en meeslepend. \
            Verwacht klassiekers als "The Chain", "Landslide", "Rhiannon" en "Don't Stop".
            """,
            imageURL: "https://iconicfestival.nl/wp-content/uploads/2025/03/The-Cosmic-Carnival-Tribute-to-Fleetwood-Mac-Bandfoto.webp",
            genre: "Psychedelische Rock",
            socials: ArtistSocials(
                website: "https://www.thecosmiccarnival.com/",
                instagram: "https://www.instagram.com/thecosmiccarnival/",
                facebook: "https://www.facebook.com/thecosmiccarnival",
                youtube: "https://www.youtube.com/user/thecosmiccarnival"
            )
        ),
        Artist(
            name: "Treasure",
            tributeTo: "Bruno Mars",
            description: """
            Winnaar van The Tribute – Battle of the Bands 2025! Treasure levert de complete \
            Bruno Mars concertervaring met een volledig gechoreografeerde show en 8-koppige band. \
            Van "Uptown Funk" tot "24K Magic" – deze band brengt de choreografie, de blazers en \
            die onweerstaanbare groove die Bruno Mars wereldberoemd maakte. Entertainment op het \
            allerhoogste niveau.
            """,
            imageURL: "https://iconicfestival.nl/wp-content/uploads/2025/03/blij.webp",
            genre: "Pop / R&B",
            socials: ArtistSocials(
                website: "https://www.treasuretribute.nl/",
                instagram: "https://www.instagram.com/treasuretributetobruno/",
                youtube: "https://www.youtube.com/@treasuretribute"
            )
        ),
        Artist(
            name: "Donna's Hot Stuff",
            tributeTo: "Donna Summer",
            description: """
            Een 13-koppige tributeband die het erfgoed van discokoningin Donna Summer viert! \
            Met de Nederlandse zangeres Irma Derby aan het roer brengt Donna's Hot Stuff \
            iconische hits als "Hot Stuff", "I Feel Love" en "Last Dance" tot leven. De \
            formatie bestaat uit een liveband, achtergrondzangeressen, kopersectie, percussie \
            én dansers. Winnaar van The Tribute – Battle of the Bands seizoen 5. \
            Maak je klaar om de nacht door te dansen!
            """,
            imageURL: "https://iconicfestival.nl/wp-content/uploads/2025/11/Donna_s-Hot-Stuff_CREDITS-WILLIAM-RUTTE-min-scaled.jpg",
            genre: "Disco",
            socials: ArtistSocials(
                website: "https://donnashotstuff.nl/",
                instagram: "https://www.instagram.com/DonnasHotStuff/",
                facebook: "https://www.facebook.com/donnashotstuff"
            )
        ),
        Artist(
            name: "Dirty Daddies",
            tributeTo: nil,
            description: """
            Deze zevenkoppige Nederlandse coverband sluit het festival in stijl af! De \
            witgeklede beste vrienden toeren al meer dan tien jaar door het land met \
            onbeperkte passie, bombast en vuurwerk. Ze verkochten meerdere keren AFAS Live \
            en Ahoy uit. Hun setlist spant van rock en disco tot hits van de jaren '70 tot nu. \
            Het geheim? Pure magie door hun ongekende interactie met het publiek. \
            Verwacht een onvergetelijk feest!
            """,
            imageURL: "https://iconicfestival.nl/wp-content/uploads/2025/03/thedirtydaddies_2024_liggend-scaled.jpg",
            genre: "Rock / Party",
            socials: ArtistSocials(
                website: "https://thedirtydaddies.com/",
                instagram: "https://www.instagram.com/thedirtydaddies/",
                facebook: "https://www.facebook.com/TheDirtyDaddies"
            )
        ),

        // Theater Stage
        Artist(
            name: "ABBA GOLD Europe",
            tributeTo: "ABBA",
            description: """
            Met voormalige castleden van de Londense productie van Mamma Mia! brengt \
            ABBA GOLD Europe de grootste hits van ABBA met authenticiteit en theatrale \
            flair. Twee vrouwelijke vocalisten en een rockband leveren het repertoire in \
            zijn originele vorm – van "Dancing Queen" en "Waterloo" tot "The Winner Takes \
            It All". Een onvergetelijke show vol energie, gezelligheid en ABBA's grootste \
            hits. Dit wordt een echt ABBA-feest!
            """,
            imageURL: "https://iconicfestival.nl/wp-content/uploads/2025/02/IMG_3046.jpg",
            genre: "Pop / Disco",
            socials: ArtistSocials(
                website: "https://abbagoldeurope.com/",
                facebook: "https://www.facebook.com/pages/Abba-Gold-Europe/110662948785",
                youtube: "https://www.youtube.com/user/abbagoldeurope"
            )
        ),
        Artist(
            name: "Urban Solitude",
            tributeTo: "Anouk",
            description: """
            De meest authentieke Anouk tributeband van Nederland en België! Urban Solitude \
            vangt de essentie van Anouks krachtige songs, kenmerkende stem en dynamische \
            podiumprésence. Van rock-anthems als "Nobody's Wife" en "R U Kiddin' Me" tot \
            emotionele ballades als "Lost" – ze eren het Nederlandse rock-icoon met \
            authenticiteit en rauwe kracht door haar hele carrière heen.
            """,
            imageURL: "https://iconicfestival.nl/wp-content/uploads/2025/03/Anouk-Tribute-Urban-Solitude-Mariska-en-MIke-1024x1024-1.jpg",
            genre: "Rock / Pop",
            socials: ArtistSocials(
                website: "https://urbansolitude.nl/",
                instagram: "https://www.instagram.com/urbansolitudeanouk/",
                facebook: "https://www.facebook.com/UrbanSolitudeTribute",
                youtube: "https://www.youtube.com/@UrbanSolitudeTribute"
            )
        ),
        Artist(
            name: "Future Nostalgia",
            tributeTo: "Dua Lipa",
            description: """
            Een reis door moderne disco-pop die een hele generatie definieerde! Future \
            Nostalgia brengt het beste van Dua Lipa's muziek met een mix van retro \
            disco-esthetiek en hedendaagse productie. Verwacht hits als "Don't Start Now", \
            "Physical", "Levitating", "Break My Heart", "New Rules", "One Kiss" en \
            "Cold Heart". Dans mee op de beats die de wereld veroverden!
            """,
            imageURL: "https://iconicfestival.nl/wp-content/uploads/2025/11/Scherm\u{00AD}afbeelding-2025-11-04-om-14.51.28.png",
            genre: "Pop / Dance",
            socials: ArtistSocials(
                website: "https://futurenostalgiadle.com/",
                instagram: "https://www.instagram.com/futureenostalgiaa_/",
                youtube: "https://www.youtube.com/@FutureNostalgia-o4r"
            )
        ),
        Artist(
            name: "The Dutch Queen",
            tributeTo: "Queen",
            description: """
            Vijf gerenommeerde Nederlandse muzikanten brengen het oeuvre van Queen tot leven! \
            Van "Bohemian Rhapsody" en "We Will Rock You" tot diepere pareltjes en epische \
            ballades – The Dutch Queen vangt de essentie van de legendarische band. Met \
            Merijn van Haren (The Analogues, Navarone) op zang, Kees Lewiszong (Navarone, \
            Douwe Bob) op gitaar, Joost van Haaren (Krezip, Novastar) op bas, Henk Jan \
            Heuvelink (Marike Jager, Klein Orkest) op keys en Tim van Delft (De Staat) op \
            drums. Een eerbetoon aan Freddie Mercury, Brian May, Roger Taylor en John Deacon.
            """,
            imageURL: "https://iconicfestival.nl/wp-content/uploads/2025/12/about-bg-scaled-1-e1765997380313.jpg",
            genre: "Rock",
            socials: ArtistSocials(
                website: "https://thedutchqueen.com/",
                instagram: "https://www.instagram.com/the_dutch_queen/",
                facebook: "https://www.facebook.com/thedutchqueen"
            )
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
