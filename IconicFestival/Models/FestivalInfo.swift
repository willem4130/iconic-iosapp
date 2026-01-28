import Foundation

// MARK: - FAQ Item

/// Veelgestelde vraag
struct FAQItem: Identifiable, Codable, Hashable {
    let id: UUID
    let question: String
    let answer: String
    let category: FAQCategory

    init(id: UUID = UUID(), question: String, answer: String, category: FAQCategory) {
        self.id = id
        self.question = question
        self.answer = answer
        self.category = category
    }
}

/// FAQ categorieën
enum FAQCategory: String, CaseIterable, Identifiable, Codable, Hashable {
    case tickets = "Tickets"
    case practical = "Praktische Info"
    case food = "Eten & Drinken"
    case safety = "Veiligheid & Regels"
    case accessibility = "Toegankelijkheid"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .tickets: return "ticket.fill"
        case .practical: return "info.circle.fill"
        case .food: return "fork.knife"
        case .safety: return "shield.checkered"
        case .accessibility: return "figure.roll"
        }
    }
}

// MARK: - Contact Info

/// Contactinformatie voor het festival
struct ContactInfo {
    let email: String
    let phone: String
    let website: String
    let instagram: String
    let instagramURL: String
    let facebook: String
    let linktree: String
    let emergencyPhone: String
}

// MARK: - Festival Info Data

/// Statische festival informatie
enum FestivalInfo {

    // MARK: - Contact

    static let contact = ContactInfo(
        email: "info@iconicfestival.nl",
        phone: "+31 24 123 4567",
        website: "https://www.iconicfestival.nl",
        instagram: "@iconic_festival",
        instagramURL: "https://www.instagram.com/iconic_festival/",
        facebook: "IconicFestivalNL",
        linktree: "https://linktr.ee/iconic_festival",
        emergencyPhone: "112"
    )

    // MARK: - Venue Info

    static let venueAddress = """
    Goffertpark
    Steinweglaan 2
    6532 AE Nijmegen
    """

    static let parkingInfo = """
    Met de auto: Navigeer naar Slotemaker de Bruïneweg
    Parkeren: Beschikbaar, volg borden ter plaatse

    Wij raden openbaar vervoer of de fiets aan!
    """

    static let publicTransportInfo = """
    Met de trein/bus:
    - Vanaf Nijmegen Centraal: 30 minuten lopen
    - Vanaf Station Goffert: 15 minuten lopen

    Met de fiets:
    - Fietsparkeren op het grote weiland bij de Goffert
    - Volg de borden
    """

    // MARK: - Opening Hours

    static let openingHours = """
    Poorten open: 13:00
    Programma start: 14:00
    Festival eindigt: 00:00
    """

    // MARK: - Ticket Info

    static let ticketPrices = """
    Early Bird: €37,50
    Groepsticket: €37,50 (per 5 personen)
    Regulier: €39,50
    Late: €42,50
    (+ €1,00 servicekosten)

    Kinderen tot 12 jaar: GRATIS
    """

    static let ticketInfo = """
    Tickets verkrijgbaar via Weeztix op iconicfestival.nl
    Niet terugbetaalbaar, wel doorverkopen via Ticketswap
    """

    // MARK: - FAQ Items

    static let faqItems: [FAQItem] = [
        // Tickets
        FAQItem(
            question: "Waar kan ik tickets kopen?",
            answer: "Tickets zijn verkrijgbaar op iconicfestival.nl of via onze officiële ticketpartner Weeztix. Wij raden aan om vooraf te kopen, want het festival is vaak uitverkocht!",
            category: .tickets
        ),
        FAQItem(
            question: "Kan ik mijn ticket terugkrijgen?",
            answer: "Tickets zijn niet restitueerbaar, maar je kunt ze doorverkopen via ons officiële doorverkoopplatform op iconicfestival.nl. Dit zorgt ervoor dat zowel koper als verkoper beschermd zijn.",
            category: .tickets
        ),
        FAQItem(
            question: "Is mijn ticket overdraagbaar?",
            answer: "Ja! Je kunt je ticket aan iemand anders overdragen via onze website. De nieuwe eigenaar ontvangt een gepersonaliseerd ticket met zijn/haar naam.",
            category: .tickets
        ),
        FAQItem(
            question: "Wat zit er bij VIP-tickets inbegrepen?",
            answer: "VIP-tickets bevatten: snelle toegang, exclusief kijkgebied bij beide podia, privébar en toiletten, VIP-lounge met zitplaatsen, gratis welkomstdrankje en een festivalgoodybag.",
            category: .tickets
        ),

        // Praktisch
        FAQItem(
            question: "Hoe laat gaan de poorten open?",
            answer: "De poorten openen om 13:00 uur. De eerste act begint om 14:00 uur op het Main Stage. Wij raden aan om vroeg te komen zodat je het festivalterrein kunt verkennen!",
            category: .practical
        ),
        FAQItem(
            question: "Wat moet ik meenemen?",
            answer: "Aanbevolen items: geldig ID, je ticket (digitaal of geprint), zonnebrand, comfortabele schoenen, regenjas (voor het geval dat!), en contant geld (sommige verkopers accepteren alleen contant). Vergeet je goede humeur niet!",
            category: .practical
        ),
        FAQItem(
            question: "Wat is NIET toegestaan?",
            answer: "Verboden items zijn: professionele camera's, drones, glazen flessen, vuurwerk, wapens, illegale middelen, huisdieren (behalve hulphonden), grote paraplu's en selfiesticks.",
            category: .practical
        ),
        FAQItem(
            question: "Is er een garderobe?",
            answer: "Ja! We hebben een garderobe bij de hoofdingang. Het is €5 per item. Wij raden lockers aan voor waardevolle spullen (€3/dag, op=op).",
            category: .practical
        ),
        FAQItem(
            question: "Mag ik het festival weer betreden na vertrek?",
            answer: "Ja, herbetreding is toegestaan tot 22:00 uur. Zorg dat je een polsbandje krijgt bij de uitgang voordat je vertrekt. Na 22:00 uur zijn de uitgangen alleen uitgang.",
            category: .practical
        ),

        // Eten & Drinken
        FAQItem(
            question: "Welk eten is er beschikbaar?",
            answer: "We hebben een grote verscheidenheid aan eetkramen met: Hollandse klassiekers, Aziatische keuken, Mexicaans, Italiaans, BBQ, vegetarische/veganistische opties en meer! Alle dieetwensen worden verzorgd.",
            category: .food
        ),
        FAQItem(
            question: "Is er een watertappunt?",
            answer: "Ja! Gratis watertappunten zijn verspreid over het festivalterrein. Je kunt ook waterflessen kopen bij elke bar. Blijf gehydrateerd!",
            category: .food
        ),
        FAQItem(
            question: "Hoe werken betalingen?",
            answer: "We gebruiken een cashless betalingssysteem met munten. Je kunt je muntsaldo opwaarderen op meerdere punten op het festival of via onze app. Kaartbetalingen worden ook geaccepteerd bij de meeste verkopers.",
            category: .food
        ),
        FAQItem(
            question: "Mag ik eigen eten/drinken meenemen?",
            answer: "Kleine snacks zijn toegestaan, maar geen grote koelboxen of glazen containers. Alcoholhoudende dranken van buiten zijn strikt verboden. Verzegelde waterflessen (max 0,5L, geen glas) zijn wel toegestaan.",
            category: .food
        ),

        // Veiligheid
        FAQItem(
            question: "Is er medische hulp aanwezig?",
            answer: "Ja, we hebben een volledig uitgeruste EHBO-post bij de ingang van het Main Stage. Ons medisch team is getraind voor alle noodgevallen. Neem bij nood contact op met een medewerker of bel 112.",
            category: .safety
        ),
        FAQItem(
            question: "Wat als ik iets verlies?",
            answer: "Bezoek onze Gevonden Voorwerpen stand bij de hoofdingang. Na het festival kun je contact met ons opnemen via info@iconicfestival.nl. Wij bewaren gevonden voorwerpen 30 dagen.",
            category: .safety
        ),
        FAQItem(
            question: "Waar meld ik incidenten?",
            answer: "Als je getuige bent van of een incident ervaart, meld dit dan onmiddellijk bij onze beveiligingsmedewerkers (in gele hesjes) of bezoek het informatiepunt bij de ingang.",
            category: .safety
        ),

        // Toegankelijkheid
        FAQItem(
            question: "Is het festival rolstoeltoegankelijk?",
            answer: "Ja! Het festivalterrein is volledig rolstoeltoegankelijk. We hebben speciale kijkplatforms bij beide podia, toegankelijke toiletten en personeel om te helpen. Neem vooraf contact met ons op voor speciale regelingen.",
            category: .accessibility
        ),
        FAQItem(
            question: "Is er parkeren voor gehandicapte bezoekers?",
            answer: "Ja, we hebben aangewezen gehandicaptenparkeerplaatsen dicht bij de ingang. Toon alsjeblieft je gehandicaptenparkeerkaart. Wij raden aan om je plek vooraf te reserveren via onze website.",
            category: .accessibility
        ),
        FAQItem(
            question: "Kan ik gratis een begeleider meenemen?",
            answer: "Bezoekers met een begeleiderskaart (bijv. 'MeePlus' of vergelijkbaar) kunnen één begeleider gratis meenemen. Registreer dit alsjeblieft vooraf zodat we ons kunnen voorbereiden.",
            category: .accessibility
        )
    ]

    // MARK: - Grouped FAQ

    /// FAQ items gegroepeerd per categorie
    static var faqByCategory: [FAQCategory: [FAQItem]] {
        Dictionary(grouping: faqItems) { $0.category }
    }
}
