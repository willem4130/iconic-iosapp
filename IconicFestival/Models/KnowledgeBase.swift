import Foundation

// MARK: - Knowledge Base Models

/// Root structure for the knowledge base JSON
struct KnowledgeBase: Codable {
    let festival: FestivalBasics
    let editie2026: Edition2026
    let tickets: TicketInfo
    let geschiedenis: History
    let bereikbaarheid: Accessibility
    let faciliteiten: Facilities
    let regels: Rules
    let doelgroep: TargetAudience
    let onlinePresence: OnlinePresence
    let contact: ContactDetails
    let partners: Partners
    let reviews: Reviews
    let uniqueSellingPoints: [String]
    let feitenCijfers: FactsFigures
    let faq: [FAQEntry]
    let metadata: Metadata

    enum CodingKeys: String, CodingKey {
        case festival
        case editie2026 = "editie_2026"
        case tickets
        case geschiedenis
        case bereikbaarheid
        case faciliteiten
        case regels
        case doelgroep
        case onlinePresence = "online_presence"
        case contact
        case partners
        case reviews
        case uniqueSellingPoints = "unique_selling_points"
        case feitenCijfers = "feiten_cijfers"
        case faq
        case metadata
    }
}

// MARK: - Festival Basics

struct FestivalBasics: Codable {
    let naam: String
    let tagline: String
    let type: String
    let stad: String
    let land: String
}

// MARK: - Edition 2026

struct Edition2026: Codable {
    let datum: String
    let dag: String
    let locatie: LocationInfo
    let tijden: Times
    let lineup: [LineupAct]
    let nieuweFeatures: [String]

    enum CodingKeys: String, CodingKey {
        case datum, dag, locatie, tijden, lineup
        case nieuweFeatures = "nieuwe_features"
    }
}

struct LocationInfo: Codable {
    let naam: String
    let adres: String
    let wijziging: String
}

struct Times: Codable {
    let deurenOpen: String
    let startProgramma: String
    let einde: String

    enum CodingKeys: String, CodingKey {
        case deurenOpen = "deuren_open"
        case startProgramma = "start_programma"
        case einde
    }
}

struct LineupAct: Codable {
    let naam: String
    let tributeVoor: String?
    let omschrijving: String?
    let rol: String?
    let bijzonder: String?
    let stijl: String?
    let genres: [String]?
    let genre: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case naam
        case tributeVoor = "tribute_voor"
        case omschrijving, rol, bijzonder, stijl, genres, genre, status
    }
}

// MARK: - Ticket Info

struct TicketInfo: Codable {
    let prijzen: Prices
    let gratis: String
    let specialeTickets: [String]
    let verkoop: SalesInfo
    let beleid: TicketPolicy

    enum CodingKeys: String, CodingKey {
        case prijzen, gratis
        case specialeTickets = "speciale_tickets"
        case verkoop, beleid
    }
}

struct Prices: Codable {
    let earlyBird: Double
    let groepsticket: Double
    let regulier: Double
    let late: Double
    let servicekosten: Double
    let valuta: String

    enum CodingKeys: String, CodingKey {
        case earlyBird = "early_bird"
        case groepsticket, regulier, late, servicekosten, valuta
    }
}

struct SalesInfo: Codable {
    let platform: String
    let website: String
    let wederverkoop: String
}

struct TicketPolicy: Codable {
    let terugbetaling: Bool
    let wederverkoopMogelijk: Bool
    let uniekeBarcode: Bool
    let sealedTickets: String

    enum CodingKeys: String, CodingKey {
        case terugbetaling
        case wederverkoopMogelijk = "wederverkoop_mogelijk"
        case uniekeBarcode = "unieke_barcode"
        case sealedTickets = "sealed_tickets"
    }
}

// MARK: - History

struct History: Codable {
    let oprichting: Int
    let oprichters: [Founder]
    let oorsprong: String
    let edities: [HistoricEdition]
}

struct Founder: Codable {
    let naam: String
}

struct HistoricEdition: Codable {
    let jaar: Int
    let editie: Int?
    let datum: String?
    let locatie: String?
    let bezoekers: String?
    let status: String
}

// MARK: - Accessibility

struct Accessibility: Codable {
    let auto: CarAccess
    let openbaarVervoer: PublicTransport
    let fiets: BikeAccess

    enum CodingKeys: String, CodingKey {
        case auto
        case openbaarVervoer = "openbaar_vervoer"
        case fiets
    }
}

struct CarAccess: Codable {
    let navigatie: String
    let parkeren: String
}

struct PublicTransport: Codable {
    let nijmegenCentraal: String
    let stationGoffert: String

    enum CodingKeys: String, CodingKey {
        case nijmegenCentraal = "nijmegen_centraal"
        case stationGoffert = "station_goffert"
    }
}

struct BikeAccess: Codable {
    let fietsparkeren: String
    let instructie: String
}

// MARK: - Facilities

struct Facilities: Codable {
    let podia: Stages
    let betalen: PaymentInfo
    let horeca: FoodAndDrinks
    let voorzieningen: [String]
    let toegang: AccessInfo
}

struct Stages: Codable {
    let mainstage: String
    let kleinPodium: String
    let goffertTheater: String

    enum CodingKeys: String, CodingKey {
        case mainstage
        case kleinPodium = "klein_podium"
        case goffertTheater = "goffert_theater"
    }
}

struct PaymentInfo: Codable {
    let methoden: [String]
    let contant: Bool
}

struct FoodAndDrinks: Codable {
    let bars: String
    let drankassortiment: [String]
    let specials: String
    let eten: String
}

struct AccessInfo: Codable {
    let inEnUitlopen: Bool
    let polsbandjeNodig: Bool
    let procedure: String

    enum CodingKeys: String, CodingKey {
        case inEnUitlopen = "in_en_uitlopen"
        case polsbandjeNodig = "polsbandje_nodig"
        case procedure
    }
}

// MARK: - Rules

struct Rules: Codable {
    let toegestaan: [String]
    let verboden: [String]
}

// MARK: - Target Audience

struct TargetAudience: Codable {
    let leeftijd: String
    let profiel: [String]
    let sfeer: String
}

// MARK: - Online Presence

struct OnlinePresence: Codable {
    let website: String
    let socialMedia: SocialMedia

    enum CodingKeys: String, CodingKey {
        case website
        case socialMedia = "social_media"
    }
}

struct SocialMedia: Codable {
    let instagram: InstagramInfo
    let facebook: PlatformStatus
    let youtube: PlatformStatus
    let whatsapp: PlatformStatus
    let linktree: String
}

struct InstagramInfo: Codable {
    let handle: String
    let url: String
    let volgers: Int
    let volgend: Int
    let posts: Int
}

struct PlatformStatus: Codable {
    let actief: Bool
}

// MARK: - Contact

struct ContactDetails: Codable {
    let adres: Address
    let website: String
    let perskit: String
}

struct Address: Codable {
    let straat: String
    let stad: String
    let land: String
}

// MARK: - Partners

struct Partners: Codable {
    let ticketing: [String]
    let media: [String]
}

// MARK: - Reviews

struct Reviews: Codable {
    let review2025: Review2025

    enum CodingKeys: String, CodingKey {
        case review2025 = "2025"
    }
}

struct Review2025: Codable {
    let bron: String
    let rating: String
    let highlights: [String]
}

// MARK: - Facts & Figures

struct FactsFigures: Codable {
    let opgericht: Int
    let editie2026: Int
    let aantalBands2026: Int
    let bezoekers2019: String
    let duurUren: Int
    let traditie: String
    let gratisLeeftijd: String

    enum CodingKeys: String, CodingKey {
        case opgericht
        case editie2026 = "editie_2026"
        case aantalBands2026 = "aantal_bands_2026"
        case bezoekers2019 = "bezoekers_2019"
        case duurUren = "duur_uren"
        case traditie
        case gratisLeeftijd = "gratis_leeftijd"
    }
}

// MARK: - FAQ

struct FAQEntry: Codable, Identifiable {
    var id: String { vraag }
    let vraag: String
    let antwoord: String
}

// MARK: - Metadata

struct Metadata: Codable {
    let documentVersie: String
    let laatstBijgewerkt: String
    let taal: String
    let bronnenGeverifieerd: Bool
    let geschiktVoor: [String]

    enum CodingKeys: String, CodingKey {
        case documentVersie = "document_versie"
        case laatstBijgewerkt = "laatst_bijgewerkt"
        case taal
        case bronnenGeverifieerd = "bronnen_geverifieerd"
        case geschiktVoor = "geschikt_voor"
    }
}

// MARK: - Knowledge Base Manager

/// Singleton manager for loading and accessing the knowledge base
@MainActor
final class KnowledgeBaseManager {
    static let shared = KnowledgeBaseManager()

    private(set) var knowledgeBase: KnowledgeBase?
    private(set) var isLoaded = false
    private(set) var loadError: Error?

    private init() {
        loadKnowledgeBase()
    }

    /// Load knowledge base from bundled JSON file
    private func loadKnowledgeBase() {
        guard let url = Bundle.main.url(forResource: "Iconic_Festival_Knowledge_Base", withExtension: "json") else {
            loadError = KnowledgeBaseError.fileNotFound
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            knowledgeBase = try decoder.decode(KnowledgeBase.self, from: data)
            isLoaded = true
        } catch {
            loadError = error
        }
    }

    /// Reload the knowledge base (useful for testing or updates)
    func reload() {
        isLoaded = false
        loadError = nil
        loadKnowledgeBase()
    }
}

// MARK: - Errors

enum KnowledgeBaseError: LocalizedError {
    case fileNotFound
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Knowledge base JSON file not found in bundle"
        case .decodingFailed:
            return "Failed to decode knowledge base JSON"
        }
    }
}

// MARK: - Knowledge Base Extensions

extension KnowledgeBase {
    /// Build a comprehensive system prompt for AI chat
    var systemPrompt: String {
        """
        Je bent de officiële AI-assistent voor Iconic Festival 2026. Je helpt bezoekers met al hun vragen over het festival.

        BELANGRIJK: Antwoord ALLEEN op basis van onderstaande informatie. Verzin GEEN informatie die hier niet staat!

        FESTIVAL INFORMATIE:
        - Naam: \(festival.naam)
        - Tagline: \(festival.tagline)
        - Type: \(festival.type)
        - Datum: \(editie2026.dag) \(editie2026.datum)
        - Locatie: \(editie2026.locatie.naam), \(editie2026.locatie.adres)
        - Tijden: Deuren open \(editie2026.tijden.deurenOpen), programma start \(editie2026.tijden.startProgramma), einde \(editie2026.tijden.einde)

        GESCHIEDENIS:
        - Opgericht: \(geschiedenis.oprichting)
        - Oprichters: \(geschiedenis.oprichters.map { $0.naam }.joined(separator: " en "))
        - Oorsprong: \(geschiedenis.oorsprong)
        - 2026 is de \(feitenCijfers.editie2026)e editie
        - Eerste editie (2019): \(feitenCijfers.bezoekers2019) bezoekers in Valkhofpark
        - 2020: Geannuleerd wegens COVID-19
        - 2021-2025: Jaarlijks in Valkhofpark
        - 2026: Verhuizing naar Goffertpark

        LOCATIEVERANDERING 2026:
        \(editie2026.locatie.wijziging)

        LINE-UP 2026:
        \(lineupDescription)

        TICKETPRIJZEN:
        - Early Bird: €\(String(format: "%.2f", tickets.prijzen.earlyBird))
        - Groepsticket: €\(String(format: "%.2f", tickets.prijzen.groepsticket)) (per 5 personen)
        - Regulier: €\(String(format: "%.2f", tickets.prijzen.regulier))
        - Late: €\(String(format: "%.2f", tickets.prijzen.late))
        - Servicekosten: €\(String(format: "%.2f", tickets.prijzen.servicekosten))
        - \(tickets.gratis)

        BEREIKBAARHEID:
        Met de auto: Navigeer naar \(bereikbaarheid.auto.navigatie). \(bereikbaarheid.auto.parkeren)
        Met OV: Vanaf Nijmegen Centraal \(bereikbaarheid.openbaarVervoer.nijmegenCentraal), vanaf Station Goffert \(bereikbaarheid.openbaarVervoer.stationGoffert)
        Met de fiets: \(bereikbaarheid.fiets.fietsparkeren). \(bereikbaarheid.fiets.instructie)

        FACILITEITEN:
        \(faciliteiten.voorzieningen.joined(separator: ", "))

        BETALEN:
        \(faciliteiten.betalen.contant ? "Contant betalen mogelijk" : "Alleen pinnen/card, geen contant geld")

        REGELS:
        Toegestaan: \(regels.toegestaan.joined(separator: ", "))
        Verboden: \(regels.verboden.joined(separator: ", "))

        IN- EN UITLOPEN:
        \(faciliteiten.toegang.inEnUitlopen ? "Ja, mogelijk met polsbandje" : "Nee"). \(faciliteiten.toegang.procedure)

        CONTACT:
        Website: \(onlinePresence.website)
        Instagram: \(onlinePresence.socialMedia.instagram.handle)

        UNIEKE KENMERKEN:
        \(uniqueSellingPoints.map { "• \($0)" }.joined(separator: "\n"))

        DOELGROEP:
        \(doelgroep.profiel.joined(separator: ", "))
        Sfeer: \(doelgroep.sfeer)

        INSTRUCTIES:
        - Antwoord altijd vriendelijk en behulpzaam in het Nederlands
        - Gebruik ALLEEN bovenstaande informatie
        - VERZIN NOOIT informatie die hier niet staat
        - Als je iets niet weet, zeg dat eerlijk en verwijs naar iconicfestival.nl
        """
    }

    /// Format lineup for display
    private var lineupDescription: String {
        editie2026.lineup.map { act in
            var desc = "• \(act.naam)"
            if let tribute = act.tributeVoor {
                desc += " (\(tribute) tribute)"
            }
            if let bijzonder = act.bijzonder {
                desc += " - \(bijzonder)"
            }
            if let rol = act.rol {
                desc += " [\(rol)]"
            }
            return desc
        }.joined(separator: "\n")
    }

    /// Find answer for a question from FAQ
    func findFAQAnswer(for query: String) -> String? {
        let lowercased = query.lowercased()

        // Direct match
        for entry in faq {
            if lowercased.contains(entry.vraag.lowercased()) ||
               entry.vraag.lowercased().contains(lowercased) {
                return entry.antwoord
            }
        }

        // Keyword matching
        let keywords: [(keywords: [String], faqIndex: Int)] = [
            (["ticket", "kaart", "kost", "prijs"], 1),
            (["tijd", "hoe laat", "begint", "eindigt", "open"], 2),
            (["uitlopen", "inlopen", "verlaten", "terugkomen"], 3),
            (["contant", "betalen", "pin", "cash"], 4),
            (["eten", "drinken", "meenemen"], 5),
            (["kinderen", "kind", "gezin", "familie"], 6),
            (["artiest", "band", "optreden", "wie"], 7),
            (["goffertpark", "locatie", "waarom", "verhuiz"], 8),
            (["concept", "wat is"], 9),
            (["terugsturen", "annuleren", "refund"], 10),
            (["bereikbaar", "komen", "parkeren", "ov", "fiets"], 11),
            (["sealed"], 0)
        ]

        for (keywordSet, index) in keywords {
            if keywordSet.contains(where: { lowercased.contains($0) }) && index < faq.count {
                return faq[index].antwoord
            }
        }

        return nil
    }
}
