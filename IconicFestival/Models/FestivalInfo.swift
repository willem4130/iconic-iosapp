import Foundation

// MARK: - FAQ Item

/// Frequently asked question
struct FAQItem: Identifiable, Codable {
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

/// FAQ categories
enum FAQCategory: String, CaseIterable, Identifiable, Codable {
    case tickets = "Tickets"
    case practical = "Practical Info"
    case food = "Food & Drinks"
    case safety = "Safety & Rules"
    case accessibility = "Accessibility"

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

/// Contact information for the festival
struct ContactInfo {
    let email: String
    let phone: String
    let website: String
    let instagram: String
    let facebook: String
    let emergencyPhone: String
}

// MARK: - Festival Info Data

/// Static festival information
enum FestivalInfo {

    // MARK: - Contact

    static let contact = ContactInfo(
        email: "info@iconicfestival.nl",
        phone: "+31 24 123 4567",
        website: "https://www.iconicfestival.nl",
        instagram: "@iconicfestival",
        facebook: "IconicFestivalNL",
        emergencyPhone: "112"
    )

    // MARK: - Venue Info

    static let venueAddress = """
    Goffertpark
    Goffertweg 50
    6534 NC Nijmegen
    """

    static let parkingInfo = """
    Parking is available at:
    - P1 Goffertpark (main parking) - €15/day
    - P2 Winkelcentrum Dukenburg - €10/day (free shuttle)

    We recommend using public transport or bike!
    """

    static let publicTransportInfo = """
    By Train: Nijmegen Central Station, then bus 3 or 10 to Goffertpark

    By Bus: Lines 3, 10, and 300 stop at Goffertpark

    By Bike: Free guarded bike parking at the festival entrance
    """

    // MARK: - Opening Hours

    static let openingHours = """
    Gates open: 13:00
    First act: 14:00
    Last act ends: 23:30
    Festival close: 00:30
    """

    // MARK: - FAQ Items

    static let faqItems: [FAQItem] = [
        // Tickets
        FAQItem(
            question: "Where can I buy tickets?",
            answer: "Tickets are available at iconicfestival.nl or through our official ticket partner Weeztix. We recommend buying in advance as the festival often sells out!",
            category: .tickets
        ),
        FAQItem(
            question: "Can I get a refund on my ticket?",
            answer: "Tickets are non-refundable, but you can resell them through our official resale platform on iconicfestival.nl. This ensures both buyer and seller are protected.",
            category: .tickets
        ),
        FAQItem(
            question: "Is my ticket transferable?",
            answer: "Yes! You can transfer your ticket to someone else through our website. The new owner will receive a personalized ticket with their name.",
            category: .tickets
        ),
        FAQItem(
            question: "What's included in VIP tickets?",
            answer: "VIP tickets include: Fast-track entry, exclusive viewing area at both stages, private bar and toilets, VIP lounge with seating, complimentary welcome drink, and a festival gift bag.",
            category: .tickets
        ),

        // Practical
        FAQItem(
            question: "What time do the gates open?",
            answer: "Gates open at 13:00. The first act starts at 14:00 on the Main Stage. We recommend arriving early to explore the festival grounds!",
            category: .practical
        ),
        FAQItem(
            question: "What should I bring?",
            answer: "Recommended items: Valid ID, your ticket (digital or printed), sunscreen, comfortable shoes, rain jacket (just in case!), and cash (some vendors are cash-only). Don't forget your good vibes!",
            category: .practical
        ),
        FAQItem(
            question: "What's NOT allowed?",
            answer: "Prohibited items include: Professional cameras, drones, glass bottles, fireworks, weapons, illegal substances, pets (except guide dogs), large umbrellas, and selfie sticks.",
            category: .practical
        ),
        FAQItem(
            question: "Is there a cloakroom?",
            answer: "Yes! We have a cloakroom near the main entrance. It's €5 per item. We recommend using lockers for valuables (€3/day, first-come-first-served).",
            category: .practical
        ),
        FAQItem(
            question: "Can I re-enter the festival?",
            answer: "Yes, re-entry is allowed until 22:00. Make sure to get a wristband at the exit before leaving. After 22:00, the exits are one-way only.",
            category: .practical
        ),

        // Food & Drinks
        FAQItem(
            question: "What food is available?",
            answer: "We have a wide variety of food vendors offering: Dutch classics, Asian cuisine, Mexican, Italian, BBQ, vegetarian/vegan options, and more! All dietary preferences are catered for.",
            category: .food
        ),
        FAQItem(
            question: "Is there a water tap?",
            answer: "Yes! Free water taps are available throughout the festival grounds. You can also buy water bottles at any bar. Stay hydrated!",
            category: .food
        ),
        FAQItem(
            question: "How do payments work?",
            answer: "We use a cashless payment system with tokens. You can top up your token balance at multiple points around the festival or via our app. Card payments are also accepted at most vendors.",
            category: .food
        ),
        FAQItem(
            question: "Can I bring my own food/drinks?",
            answer: "Small snacks are allowed, but no large coolers or glass containers. Outside alcohol is strictly prohibited. Sealed water bottles (max 0.5L, no glass) are allowed.",
            category: .food
        ),

        // Safety
        FAQItem(
            question: "Is there medical assistance?",
            answer: "Yes, we have a fully equipped first aid station near the Main Stage entrance. Our medical team is trained for all emergencies. In case of emergency, contact any staff member or call 112.",
            category: .safety
        ),
        FAQItem(
            question: "What if I lose something?",
            answer: "Visit our Lost & Found booth near the main entrance. After the festival, you can contact us via info@iconicfestival.nl. We keep found items for 30 days.",
            category: .safety
        ),
        FAQItem(
            question: "Where do I report incidents?",
            answer: "If you witness or experience any incident, please report it immediately to our security staff (wearing yellow vests) or visit the information point near the entrance.",
            category: .safety
        ),

        // Accessibility
        FAQItem(
            question: "Is the festival wheelchair accessible?",
            answer: "Yes! The festival grounds are fully wheelchair accessible. We have dedicated viewing platforms at both stages, accessible toilets, and staff to assist. Please contact us in advance for special arrangements.",
            category: .accessibility
        ),
        FAQItem(
            question: "Is there parking for disabled visitors?",
            answer: "Yes, we have designated disabled parking close to the entrance. Please show your disabled parking card. We recommend reserving your spot in advance through our website.",
            category: .accessibility
        ),
        FAQItem(
            question: "Can I bring a companion for free?",
            answer: "Visitors with a companion card (e.g., 'MeePlus' or similar) can bring one companion for free. Please register this in advance so we can prepare.",
            category: .accessibility
        )
    ]

    // MARK: - Grouped FAQ

    /// FAQ items grouped by category
    static var faqByCategory: [FAQCategory: [FAQItem]] {
        Dictionary(grouping: faqItems) { $0.category }
    }
}
