import Foundation

/// ViewModel voor de AI chat assistent
/// Gebruikt Claude API met de volledige knowledge base als context
@MainActor
@Observable
final class ChatViewModel {

    // MARK: - Properties

    var isLoading = false
    var error: Error?
    var useAI = true // Toggle om AI aan/uit te zetten

    /// Pre-defined suggesties voor veelgestelde vragen
    let suggestions = [
        "Wanneer speelt The Dutch Queen?",
        "Welk eten is er beschikbaar?",
        "Waar kan ik parkeren?",
        "Hoe is het festival ontstaan?"
    ]

    /// Reference naar Claude service
    private let claudeService = ClaudeService.shared

    /// Check of Claude API geconfigureerd is
    var isAIConfigured: Bool {
        claudeService.isConfigured
    }

    /// Reference naar knowledge base
    private var knowledgeBase: KnowledgeBase? {
        KnowledgeBaseManager.shared.knowledgeBase
    }

    // MARK: - Response Generation

    /// Krijg AI-antwoord voor gebruikersvraag
    /// Probeert eerst Claude API, valt terug op pattern matching indien niet beschikbaar
    func getResponse(for query: String) async -> String {
        isLoading = true
        error = nil
        defer { isLoading = false }

        // Probeer Claude API als geconfigureerd en ingeschakeld
        if useAI && claudeService.isConfigured {
            do {
                let response = try await claudeService.chat(userMessage: query)
                return response
            } catch {
                self.error = error
                Log.error("Claude API fout: \(error.localizedDescription)")
                // Val terug op pattern matching
            }
        }

        // Fallback: pattern matching
        return await getOfflineResponse(for: query)
    }

    /// Offline antwoord via pattern matching (fallback)
    private func getOfflineResponse(for query: String) async -> String {
        // Kleine vertraging voor UX
        try? await Task.sleep(nanoseconds: 300_000_000)

        let lowercasedQuery = query.lowercased()

        // Probeer eerst een match in de FAQ
        if let faqAnswer = knowledgeBase?.findFAQAnswer(for: query) {
            return faqAnswer
        }

        // Pattern matching voor verschillende vraagcategorieën
        return matchQueryPattern(lowercasedQuery)
    }

    // MARK: - Query Pattern Matching

    private func matchQueryPattern(_ query: String) -> String {
        // Programma / Timetable vragen
        if query.contains("wanneer") || query.contains("tijd") || query.contains("speel") || query.contains("optred") {
            return handleTimetableQuery(query)
        }

        // Eten vragen
        if query.contains("eten") || query.contains("food") || query.contains("drinken") || query.contains("snack") || query.contains("foodtruck") {
            return handleFoodQuery()
        }

        // Parkeren vragen
        if query.contains("park") || query.contains("auto") {
            return handleParkingQuery()
        }

        // Poorten/opening vragen
        if query.contains("poort") || query.contains("open") || query.contains("begin") || query.contains("start") || query.contains("eind") {
            return handleTimesQuery()
        }

        // Ticket vragen
        if query.contains("ticket") || query.contains("kaart") || query.contains("prijs") || query.contains("kost") {
            return handleTicketQuery()
        }

        // Podium vragen
        if query.contains("podium") || query.contains("stage") {
            return handleStageQuery()
        }

        // Locatie vragen
        if query.contains("locatie") || query.contains("adres") || query.contains("waar") || query.contains("goffert") {
            return handleLocationQuery()
        }

        // Bereikbaarheid vragen
        if query.contains("ov") || query.contains("trein") || query.contains("bus") || query.contains("fiets") || query.contains("komen") {
            return handleTransportQuery()
        }

        // Regels vragen
        if query.contains("regel") || query.contains("mag") || query.contains("verboden") || query.contains("meenemen") {
            return handleRulesQuery()
        }

        // Betalen vragen
        if query.contains("betal") || query.contains("pin") || query.contains("contant") || query.contains("cash") {
            return handlePaymentQuery()
        }

        // In- en uitlopen
        if query.contains("uitlopen") || query.contains("inlopen") || query.contains("verlaten") || query.contains("terug") {
            return handleReentryQuery()
        }

        // Kinderen / Familie
        if query.contains("kind") || query.contains("gezin") || query.contains("familie") {
            return handleFamilyQuery()
        }

        // Geschiedenis / Ontstaan
        if query.contains("ontstaan") || query.contains("geschied") || query.contains("opgericht") || query.contains("oprichter") || query.contains("begonnen") || query.contains("eerste editie") || query.contains("hoe lang") || query.contains("sinds wanneer") {
            return handleHistoryQuery()
        }

        // Wat is / Over het festival
        if query.contains("wat is iconic") || query.contains("wat voor festival") || query.contains("concept") {
            return handleAboutQuery()
        }

        // Contact / Social media
        if query.contains("contact") || query.contains("instagram") || query.contains("social") || query.contains("website") || query.contains("mail") || query.contains("telefoon") {
            return handleContactQuery()
        }

        // Reviews / Ervaringen
        if query.contains("review") || query.contains("ervaring") || query.contains("mening") || query.contains("hoe was") || query.contains("vorig jaar") {
            return handleReviewQuery()
        }

        // Vorige edities
        if query.contains("editie") || query.contains("vorige jaar") || query.contains("2025") || query.contains("2024") || query.contains("2023") || query.contains("2022") || query.contains("2021") || query.contains("2019") {
            return handleEditionsQuery()
        }

        // Line-up vragen
        if query.contains("line-up") || query.contains("lineup") || query.contains("wie treedt op") || query.contains("welke bands") || query.contains("artiesten") {
            return handleLineupQuery()
        }

        // Waarom / USPs
        if query.contains("waarom") || query.contains("bijzonder") || query.contains("speciaal") || query.contains("uniek") {
            return handleUSPQuery()
        }

        // Artiest specifieke vragen
        if let artistResponse = handleArtistQuery(query) {
            return artistResponse
        }

        // Standaard antwoord met festival overzicht
        return handleDefaultQuery()
    }

    // MARK: - Query Handlers

    private func handleTimetableQuery(_ query: String) -> String {
        // Check voor specifieke artiest
        for artist in FestivalData.artists {
            if query.contains(artist.name.lowercased()) ||
               (artist.tributeTo != nil && query.contains(artist.tributeTo!.lowercased())) {
                if let performance = FestivalData.createTimetable().first(where: { $0.artist.name == artist.name }) {
                    return "\(artist.name) speelt op het \(performance.stage.rawValue) van \(performance.timeRange)!"
                }
            }
        }

        // Volledig programma
        let mainStage = FestivalData.performancesByStage()[.mainStage]?.sorted { $0.startTime < $1.startTime } ?? []
        let theater = FestivalData.performancesByStage()[.theater]?.sorted { $0.startTime < $1.startTime } ?? []

        let mainSchedule = mainStage.map { "\(timeString($0.startTime)) - \($0.artist.name)\($0.isHeadliner ? " (HEADLINER)" : "")" }.joined(separator: "\n")
        let theaterSchedule = theater.map { "\(timeString($0.startTime)) - \($0.artist.name)\($0.isHeadliner ? " (HEADLINER)" : "")" }.joined(separator: "\n")

        return """
        ICONIC FESTIVAL 2026 PROGRAMMA

        MAIN STAGE:
        \(mainSchedule)

        OPENLUCHTTHEATER:
        \(theaterSchedule)

        Vraag me naar een specifieke artiest voor meer details!
        """
    }

    private func handleFoodQuery() -> String {
        guard let kb = knowledgeBase else {
            return defaultFoodResponse()
        }

        return """
        Eten & Drinken op Iconic Festival 2026:

        BARS:
        \(kb.faciliteiten.horeca.bars)
        Assortiment: \(kb.faciliteiten.horeca.drankassortiment.joined(separator: ", "))
        Specials: \(kb.faciliteiten.horeca.specials)

        ETEN:
        \(kb.faciliteiten.horeca.eten)
        Dit jaar meer foodtrucks dan ooit!

        BETALEN:
        \(kb.faciliteiten.betalen.contant ? "Contant en pin" : "Alleen pinnen/card - geen contant geld!")

        LET OP: Eigen eten en drinken is niet toegestaan, met uitzondering van waterflessen.
        """
    }

    private func defaultFoodResponse() -> String {
        """
        Eten & Drinken op Iconic Festival:

        • Diverse foodtrucks met breed aanbod
        • Meerdere bars met alcoholische en alcoholvrije dranken
        • Speciale cocktailbar
        • Alleen pinnen - geen contant geld!

        Eigen eten en drinken niet toegestaan (behalve waterflessen).
        """
    }

    private func handleParkingQuery() -> String {
        guard let kb = knowledgeBase else {
            return FestivalInfo.parkingInfo
        }

        return """
        Parkeren bij Iconic Festival 2026:

        MET DE AUTO:
        Navigeer naar: \(kb.bereikbaarheid.auto.navigatie)
        \(kb.bereikbaarheid.auto.parkeren)

        ALTERNATIEF:
        Wij raden aan om met openbaar vervoer of fiets te komen!

        FIETSPARKEREN:
        \(kb.bereikbaarheid.fiets.fietsparkeren)
        \(kb.bereikbaarheid.fiets.instructie)
        """
    }

    private func handleTimesQuery() -> String {
        guard let kb = knowledgeBase else {
            return FestivalInfo.openingHours
        }

        return """
        Openingstijden Iconic Festival 2026:

        Deuren open: \(kb.editie2026.tijden.deurenOpen)
        Programma start: \(kb.editie2026.tijden.startProgramma)
        Festival eindigt: \(kb.editie2026.tijden.einde)

        Eerste act: 14:00 (Beach Boys' Best op Main Stage)
        Headliners: The Dirty Daddies & The Dutch Queen

        Wij raden aan om vroeg te komen om het terrein te verkennen!
        """
    }

    private func handleTicketQuery() -> String {
        guard let kb = knowledgeBase else {
            return defaultTicketResponse()
        }

        return """
        Tickets Iconic Festival 2026:

        PRIJZEN:
        • Early Bird: €\(String(format: "%.2f", kb.tickets.prijzen.earlyBird))
        • Groepsticket: €\(String(format: "%.2f", kb.tickets.prijzen.groepsticket)) (per 5 personen)
        • Regulier: €\(String(format: "%.2f", kb.tickets.prijzen.regulier))
        • Late: €\(String(format: "%.2f", kb.tickets.prijzen.late))
        (+ €\(String(format: "%.2f", kb.tickets.prijzen.servicekosten)) servicekosten)

        GRATIS: \(kb.tickets.gratis)

        SPECIALE TICKETS:
        \(kb.tickets.specialeTickets.map { "• \($0)" }.joined(separator: "\n"))

        KOPEN:
        Platform: \(kb.tickets.verkoop.platform)
        Website: \(kb.tickets.verkoop.website)
        Wederverkoop: \(kb.tickets.verkoop.wederverkoop)

        Let op: Tickets zijn niet terugbetaalbaar maar wel door te verkopen via Ticketswap.
        """
    }

    private func defaultTicketResponse() -> String {
        """
        Tickets Iconic Festival:

        • Early Bird: €37,50
        • Regulier: €39,50
        • Late: €42,50
        • Kinderen tot 12 jaar: GRATIS

        Koop tickets op iconicfestival.nl via Weeztix.
        Niet terugbetaalbaar, wel door te verkopen via Ticketswap.
        """
    }

    private func handleStageQuery() -> String {
        let mainStage = FestivalData.performancesByStage()[.mainStage] ?? []
        let theater = FestivalData.performancesByStage()[.theater] ?? []

        let mainActs = mainStage.map { $0.artist.name }.joined(separator: ", ")
        let theaterActs = theater.map { $0.artist.name }.joined(separator: ", ")

        return """
        Iconic Festival heeft twee podia:

        MAIN STAGE (Goffertpark)
        Capaciteit: 5000
        Acts: \(mainActs)
        Headliner: Dirty Daddies

        OPENLUCHTTHEATER
        Capaciteit: 2000
        Acts: \(theaterActs)
        Headliner: The Dutch Queen (Queen tribute)

        NIEUW IN 2026:
        • Grotere mainstage
        • Tweede podium bij Goffert Theater
        • Verrassende acts verspreid over het terrein
        """
    }

    private func handleLocationQuery() -> String {
        guard let kb = knowledgeBase else {
            return defaultLocationResponse()
        }

        return """
        Locatie Iconic Festival 2026:

        \(kb.editie2026.locatie.naam)
        \(kb.editie2026.locatie.adres)

        NIEUW: \(kb.editie2026.locatie.wijziging)

        VOORDELEN NIEUWE LOCATIE:
        \(kb.editie2026.nieuweFeatures.map { "• \($0)" }.joined(separator: "\n"))
        """
    }

    private func defaultLocationResponse() -> String {
        """
        Locatie: Goffertpark, Nijmegen
        Adres: Steinweglaan 2, 6532 AE Nijmegen

        Nieuw in 2026: Verhuisd van Valkhofpark naar Goffertpark voor meer ruimte!
        """
    }

    private func handleTransportQuery() -> String {
        guard let kb = knowledgeBase else {
            return FestivalInfo.publicTransportInfo
        }

        return """
        Bereikbaarheid Iconic Festival 2026:

        MET DE TREIN/BUS:
        Vanaf Nijmegen Centraal: \(kb.bereikbaarheid.openbaarVervoer.nijmegenCentraal)
        Vanaf Station Goffert: \(kb.bereikbaarheid.openbaarVervoer.stationGoffert)

        MET DE FIETS:
        \(kb.bereikbaarheid.fiets.fietsparkeren)
        \(kb.bereikbaarheid.fiets.instructie)

        MET DE AUTO:
        Navigeer naar: \(kb.bereikbaarheid.auto.navigatie)
        \(kb.bereikbaarheid.auto.parkeren)

        TIP: Wij raden openbaar vervoer of de fiets aan!
        """
    }

    private func handleRulesQuery() -> String {
        guard let kb = knowledgeBase else {
            return defaultRulesResponse()
        }

        return """
        Regels Iconic Festival 2026:

        TOEGESTAAN:
        \(kb.regels.toegestaan.map { "✓ \($0)" }.joined(separator: "\n"))

        VERBODEN:
        \(kb.regels.verboden.map { "✗ \($0)" }.joined(separator: "\n"))

        BETALEN:
        \(kb.faciliteiten.betalen.contant ? "Contant en pin mogelijk" : "Alleen pinnen/card - geen contant!")
        """
    }

    private func defaultRulesResponse() -> String {
        """
        Regels Iconic Festival:

        TOEGESTAAN:
        ✓ Hervulbare waterflessen

        VERBODEN:
        ✗ Drugs
        ✗ Wapens
        ✗ Scherpe voorwerpen
        ✗ Glas
        ✗ Eigen eten en drinken (behalve water)

        Alleen pinnen - geen contant geld!
        """
    }

    private func handlePaymentQuery() -> String {
        guard let kb = knowledgeBase else {
            return "Op het festivalterrein kan alleen met pin/card worden betaald. Contant geld wordt niet geaccepteerd."
        }

        let methods = kb.faciliteiten.betalen.methoden.joined(separator: ", ")
        return """
        Betalen op Iconic Festival:

        Betaalmethoden: \(methods)
        Contant geld: \(kb.faciliteiten.betalen.contant ? "Ja" : "Nee, niet geaccepteerd")

        Zorg dat je betaalpas werkt voordat je komt!
        """
    }

    private func handleReentryQuery() -> String {
        guard let kb = knowledgeBase else {
            return "Ja, in- en uitlopen is mogelijk. Vraag bij de uitgang aan security om een polsbandje, dan kun je terugkeren naar het festivalterrein."
        }

        return """
        In- en uitlopen Iconic Festival:

        Toegestaan: \(kb.faciliteiten.toegang.inEnUitlopen ? "Ja!" : "Nee")
        Polsbandje nodig: \(kb.faciliteiten.toegang.polsbandjeNodig ? "Ja" : "Nee")

        PROCEDURE:
        \(kb.faciliteiten.toegang.procedure)

        Je kunt dus even weg om te rusten of elders te eten en later terugkomen!
        """
    }

    private func handleFamilyQuery() -> String {
        guard let kb = knowledgeBase else {
            return "Iconic Festival is familie-vriendelijk! Kinderen tot 12 jaar hebben gratis toegang. Er zijn gezinstickets beschikbaar."
        }

        return """
        Familie & Kinderen:

        KINDEREN:
        \(kb.tickets.gratis)

        GEZINSTICKETS:
        \(kb.tickets.specialeTickets.filter { $0.lowercased().contains("gezin") }.first ?? "Beschikbaar voor 2 volwassenen + 2 kinderen")

        SFEER:
        \(kb.doelgroep.sfeer)

        DOELGROEP:
        \(kb.doelgroep.profiel.joined(separator: ", "))

        Iconic Festival is geschikt voor alle leeftijden!
        """
    }

    private func handleHistoryQuery() -> String {
        guard let kb = knowledgeBase else {
            return defaultHistoryResponse()
        }

        let oprichters = kb.geschiedenis.oprichters.map { $0.naam }.joined(separator: " en ")

        return """
        De Geschiedenis van Iconic Festival:

        ONTSTAAN:
        Iconic Festival is in \(kb.geschiedenis.oprichting) opgericht door \(oprichters).

        \(kb.geschiedenis.oorsprong)

        EDITIES:
        2026 is de \(kb.feitenCijfers.editie2026)e editie!

        GROEI:
        Van \(kb.feitenCijfers.bezoekers2019) bezoekers in 2019 naar een groter publiek.
        Nu verhuisd van Valkhofpark naar het grotere Goffertpark!

        VISIE:
        "Iconic is er voor iedereen die muziek niet alleen wil horen, maar ook wil voelen."
        """
    }

    private func defaultHistoryResponse() -> String {
        """
        De Geschiedenis van Iconic Festival:

        Iconic Festival is in 2019 opgericht door Tinus Weijkamp en Willem van den Berg. Ze leerden elkaar kennen in groep 3 op de basisschool in Ruurlo en vieren met dit festival hun vriendschap van meer dan 25 jaar.

        Wat begon als een speels idee is uitgegroeid tot een succesvol jaarlijks evenement.

        2026 is de 6e editie - nu op de nieuwe locatie Goffertpark!
        """
    }

    private func handleAboutQuery() -> String {
        guard let kb = knowledgeBase else {
            return defaultAboutResponse()
        }

        return """
        Wat is Iconic Festival?

        \(kb.festival.naam) - \(kb.festival.tagline)

        TYPE: \(kb.festival.type)

        CONCEPT:
        Iconic Festival brengt de vuur en magie van muzikale helden weer tot leven door middel van de beste en meest authentieke tribute acts. Het festival presenteert een reis door decennia van iconische muziek.

        MUZIEKGENRES:
        • Classic Rock (Queen, Golden Earring, Fleetwood Mac)
        • Pop (ABBA, Bruno Mars, Dua Lipa)
        • Disco/Soul (Donna Summer)
        • Nederlandse Rock (Anouk)
        • Beach/Surf Rock (Beach Boys)

        DOELGROEP:
        \(kb.doelgroep.profiel.joined(separator: ", "))

        SFEER:
        \(kb.doelgroep.sfeer)

        UNIQUE SELLING POINTS:
        \(kb.uniqueSellingPoints.prefix(5).map { "• \($0)" }.joined(separator: "\n"))
        """
    }

    private func defaultAboutResponse() -> String {
        """
        Wat is Iconic Festival?

        Iconic Festival is het Nederlandse tribute festival dat jaarlijks de grootste muziekiconen viert met een line-up volledig gewijd aan legendarische hits.

        Het festival brengt de beste tribute acts uit binnen- en buitenland samen voor een dag vol livemuziek, sfeer en herkenning.

        Voor muziekliefhebbers van alle leeftijden - familie-vriendelijk!
        """
    }

    private func handleContactQuery() -> String {
        guard let kb = knowledgeBase else {
            return defaultContactResponse()
        }

        return """
        Contact & Social Media:

        WEBSITE:
        \(kb.onlinePresence.website)

        INSTAGRAM:
        \(kb.onlinePresence.socialMedia.instagram.handle)
        \(kb.onlinePresence.socialMedia.instagram.url)
        (\(kb.onlinePresence.socialMedia.instagram.volgers) volgers)

        LINKTREE:
        \(kb.onlinePresence.socialMedia.linktree)

        ORGANISATIE:
        \(kb.contact.adres.straat), \(kb.contact.adres.stad)

        TICKETVRAGEN:
        Via Weeztix op \(kb.tickets.verkoop.website)
        """
    }

    private func defaultContactResponse() -> String {
        """
        Contact Iconic Festival:

        Website: iconicfestival.nl
        Instagram: @iconic_festival
        Linktree: linktr.ee/iconic_festival

        Voor ticketvragen: via Weeztix op de website
        """
    }

    private func handleReviewQuery() -> String {
        guard let kb = knowledgeBase else {
            return defaultReviewResponse()
        }

        let highlights = kb.reviews.review2025.highlights.map { "• \($0)" }.joined(separator: "\n")

        return """
        Reviews Iconic Festival:

        EDITIE 2025 - \(kb.reviews.review2025.rating)
        Bron: \(kb.reviews.review2025.bron)

        HIGHLIGHTS:
        \(highlights)

        SFEER:
        \(kb.doelgroep.sfeer)
        """
    }

    private func defaultReviewResponse() -> String {
        """
        Reviews Iconic Festival:

        De editie van 2025 werd zeer positief ontvangen:
        • Zeer goed georganiseerd
        • Bands waren zeer goed
        • Prettige sfeer
        • Publiek extreem enthousiast

        "Voor mij één van de beste manieren om mijn favoriete muziek toch nog live te horen"
        """
    }

    private func handleEditionsQuery() -> String {
        guard let kb = knowledgeBase else {
            return defaultEditionsResponse()
        }

        let edities = kb.geschiedenis.edities.compactMap { editie -> String? in
            guard let editieNr = editie.editie else {
                return "• \(editie.jaar): \(editie.status)"
            }
            let locatie = editie.locatie ?? "TBA"
            return "• \(editie.jaar) (Editie \(editieNr)): \(locatie) - \(editie.status)"
        }.joined(separator: "\n")

        return """
        Overzicht van alle Iconic Festival Edities:

        \(edities)

        MIJLPALEN:
        • 2019: Eerste editie met 2000+ bezoekers
        • 2020: Geannuleerd door COVID-19
        • 2026: Verhuizing naar Goffertpark!
        """
    }

    private func defaultEditionsResponse() -> String {
        """
        Iconic Festival Edities:

        • 2019 (Editie 1): Valkhofpark - 2000+ bezoekers
        • 2020: Geannuleerd (COVID-19)
        • 2021 (Editie 2): Valkhofpark
        • 2022 (Editie 3): Valkhofpark
        • 2023 (Editie 4): Valkhofpark
        • 2025 (Editie 5): Valkhofpark
        • 2026 (Editie 6): NIEUW: Goffertpark!
        """
    }

    private func handleLineupQuery() -> String {
        guard let kb = knowledgeBase else {
            return defaultLineupResponse()
        }

        let lineup = kb.editie2026.lineup.map { act -> String in
            var desc = "• \(act.naam)"
            if let tribute = act.tributeVoor {
                desc += " (\(tribute) tribute)"
            }
            if let bijzonder = act.bijzonder {
                desc += "\n  → \(bijzonder)"
            }
            if let rol = act.rol {
                desc += " [\(rol)]"
            }
            return desc
        }.joined(separator: "\n")

        return """
        LINE-UP ICONIC FESTIVAL 2026:

        \(lineup)

        \(kb.editie2026.lineup.count) acts op 2 podia:
        • Main Stage (Goffertpark)
        • Openluchttheater (Goffert Theater)

        NIEUWE FEATURES:
        \(kb.editie2026.nieuweFeatures.map { "• \($0)" }.joined(separator: "\n"))
        """
    }

    private func defaultLineupResponse() -> String {
        """
        Line-up Iconic Festival 2026:

        10 tribute bands waaronder:
        • The Dirty Daddies (afsluiter)
        • Treasure (Bruno Mars)
        • ABBA Gold Europe
        • The Dutch Queen (Queen)
        • The Cosmic Carnival (Fleetwood Mac)
        • Coming on Strong (Golden Earring)
        • Donna's Hot Stuff (Donna Summer)
        • Beach Boys' Best
        • Future Nostalgia (Dua Lipa)
        • Urban Solitude (Anouk)
        • Mystery Band (nog aan te kondigen)
        """
    }

    private func handleUSPQuery() -> String {
        guard let kb = knowledgeBase else {
            return defaultUSPResponse()
        }

        return """
        Waarom Iconic Festival?

        UNIQUE SELLING POINTS:
        \(kb.uniqueSellingPoints.map { "✓ \($0)" }.joined(separator: "\n"))

        NIEUW IN 2026:
        \(kb.editie2026.nieuweFeatures.map { "• \($0)" }.joined(separator: "\n"))

        SFEER:
        \(kb.doelgroep.sfeer)

        VOOR WIE:
        \(kb.doelgroep.profiel.joined(separator: ", "))
        """
    }

    private func defaultUSPResponse() -> String {
        """
        Waarom Iconic Festival?

        ✓ Beste internationale tribute acts
        ✓ Diverse line-up (jaren '60 - 2010s)
        ✓ Familie-vriendelijk met gratis toegang kinderen
        ✓ Flexibele toegang (in- en uitlopen mogelijk)
        ✓ Betaalbaar vanaf €37,50
        ✓ Grotere locatie met tweede podium (2026)
        ✓ 6 jaar ervaring en trouwe bezoekers
        ✓ Intieme en overzichtelijke setting
        """
    }

    private func handleArtistQuery(_ query: String) -> String? {
        for artist in FestivalData.artists {
            if query.contains(artist.name.lowercased()) ||
               (artist.tributeTo != nil && query.contains(artist.tributeTo!.lowercased())) {
                if let performance = FestivalData.createTimetable().first(where: { $0.artist.name == artist.name }) {
                    let tribute = artist.tributeTo != nil ? " (Tribute aan \(artist.tributeTo!))" : ""
                    return """
                    \(artist.name)\(tribute)

                    Podium: \(performance.stage.rawValue)
                    Tijd: \(performance.timeRange)
                    Duur: \(performance.durationMinutes) minuten
                    Genre: \(artist.genre)
                    \(performance.isHeadliner ? "⭐ HEADLINER" : "")

                    \(artist.description)
                    """
                }
            }
        }
        return nil
    }

    private func handleDefaultQuery() -> String {
        guard let kb = knowledgeBase else {
            return defaultOverviewResponse()
        }

        return """
        Welkom bij Iconic Festival 2026!

        \(kb.festival.tagline)

        DATUM: \(kb.editie2026.dag) \(kb.editie2026.datum)
        LOCATIE: \(kb.editie2026.locatie.naam), \(kb.festival.stad)
        TIJDEN: \(kb.editie2026.tijden.deurenOpen) - \(kb.editie2026.tijden.einde)

        LINE-UP: \(kb.editie2026.lineup.count) bands waaronder:
        \(kb.editie2026.lineup.prefix(5).map { "• \($0.naam)" }.joined(separator: "\n"))
        ...en meer!

        Je kunt me vragen stellen over:
        • Specifieke bands en speeltijden
        • Tickets en prijzen
        • Eten en drinken
        • Parkeren en bereikbaarheid
        • Regels en faciliteiten

        Wat wil je weten?
        """
    }

    private func defaultOverviewResponse() -> String {
        """
        Welkom bij Iconic Festival 2026!

        Live Tribute To Your Favorite Bands

        Locatie: Goffertpark, Nijmegen
        Poorten: 13:00 | Muziek: 14:00 - 23:30

        Twee podia met geweldige tributebands!

        Vraag me over:
        • Bands en speeltijden
        • Tickets en prijzen
        • Eten en drinken
        • Parkeren en vervoer
        • Faciliteiten

        Wat wil je weten?
        """
    }

    // MARK: - Helpers

    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
