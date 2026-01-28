import SwiftUI

/// Festival informatie weergave met FAQ, locatie info en contact
struct InfoView: View {

    // MARK: - State

    @State private var selectedSection: InfoSection = .faq
    @State private var expandedFAQs: Set<UUID> = []
    @State private var searchText = ""

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Logo header
                logoHeader

                // Section picker
                sectionPicker

                // Content
                ScrollView(showsIndicators: true) {
                    switch selectedSection {
                    case .faq:
                        faqContent
                    case .venue:
                        venueContent
                    case .contact:
                        contactContent
                    }
                }
                .scrollIndicators(.visible)
            }
            .background(AppColors.background)
            .navigationBarHidden(true)
        }
    }

    // MARK: - Logo Header

    private var logoHeader: some View {
        HStack(spacing: 12) {
            Image("IconicLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 36)

            Text(FestivalData.festivalDate)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(AppColors.primaryGold)

            Spacer()

            // Social links with labels
            HStack(spacing: 12) {
                Link(destination: URL(string: FestivalInfo.contact.instagramURL)!) {
                    VStack(spacing: 2) {
                        Image(systemName: "camera.fill")
                            .font(.caption)
                        Text("Instagram")
                            .font(.system(size: 8))
                    }
                    .foregroundColor(.white.opacity(0.8))
                }

                Link(destination: URL(string: FestivalInfo.contact.facebookURL)!) {
                    VStack(spacing: 2) {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.caption)
                        Text("Facebook")
                            .font(.system(size: 8))
                    }
                    .foregroundColor(.white.opacity(0.8))
                }

                Link(destination: URL(string: FestivalInfo.contact.website)!) {
                    VStack(spacing: 2) {
                        Image(systemName: "globe")
                            .font(.caption)
                        Text("Website")
                            .font(.system(size: 8))
                    }
                    .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(AppColors.primaryDark)
    }

    // MARK: - Section Picker

    private var sectionPicker: some View {
        HStack(spacing: 0) {
            ForEach(InfoSection.allCases) { section in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedSection = section
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: section.icon)
                            .font(.caption2)
                        Text(section.rawValue)
                            .font(.caption)
                            .fontWeight(selectedSection == section ? .semibold : .regular)
                    }
                    .foregroundColor(selectedSection == section ? AppColors.primaryDark : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        selectedSection == section
                            ? AppColors.primaryWhite
                            : Color.white.opacity(0.15)
                    )
                }
            }
        }
        .cornerRadius(6)
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(AppColors.primaryDark)
    }

    // MARK: - FAQ Content

    private var faqContent: some View {
        LazyVStack(spacing: 16) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textTertiary)
                TextField("Zoek in FAQ...", text: $searchText)
            }
            .padding()
            .background(AppColors.secondaryBackground)
            .cornerRadius(10)
            .padding(.horizontal)

            // FAQ by category
            ForEach(FAQCategory.allCases) { category in
                let items = filteredFAQItems(for: category)
                if !items.isEmpty {
                    faqCategorySection(category: category, items: items)
                }
            }
        }
        .padding(.vertical)
    }

    private func faqCategorySection(category: FAQCategory, items: [FAQItem]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Category header
            HStack {
                Image(systemName: category.icon)
                    .foregroundColor(AppColors.primaryGold)
                Text(category.rawValue)
                    .font(.headline)
            }
            .padding(.horizontal)

            // FAQ items
            ForEach(items) { item in
                FAQItemView(item: item, isExpanded: expandedFAQs.contains(item.id)) {
                    withAnimation {
                        if expandedFAQs.contains(item.id) {
                            expandedFAQs.remove(item.id)
                        } else {
                            expandedFAQs.insert(item.id)
                        }
                    }
                }
            }
        }
    }

    private func filteredFAQItems(for category: FAQCategory) -> [FAQItem] {
        let categoryItems = FestivalInfo.faqByCategory[category] ?? []
        if searchText.isEmpty {
            return categoryItems
        }
        return categoryItems.filter {
            $0.question.localizedCaseInsensitiveContains(searchText) ||
            $0.answer.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Venue Content

    private var venueContent: some View {
        LazyVStack(spacing: 16) {
            // Festival date card
            VStack(alignment: .leading, spacing: 8) {
                Label("Festival Datum", systemImage: "calendar")
                    .font(.headline)
                    .foregroundColor(AppColors.primaryGold)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(FestivalData.festivalDate)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.textPrimary)

                        Text(FestivalData.festivalLocation)
                            .font(.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "music.note.house.fill")
                        .font(.largeTitle)
                        .foregroundColor(AppColors.primaryGold)
                }
                .padding()
                .background(AppColors.primaryGold.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(AppColors.primaryGold.opacity(0.3), lineWidth: 1)
                )
            }
            .padding(.horizontal)

            // Address card
            infoCard(
                title: "Locatie",
                icon: "mappin.circle.fill",
                content: FestivalInfo.venueAddress
            )

            // Opening hours
            infoCard(
                title: "Openingstijden",
                icon: "clock.fill",
                content: FestivalInfo.openingHours
            )

            // Public transport
            infoCard(
                title: "Openbaar Vervoer",
                icon: "bus.fill",
                content: FestivalInfo.publicTransportInfo
            )

            // Parking
            infoCard(
                title: "Parkeren",
                icon: "car.fill",
                content: FestivalInfo.parkingInfo
            )

            // Map placeholder
            VStack(alignment: .leading, spacing: 8) {
                Label("Plattegrond", systemImage: "map.fill")
                    .font(.headline)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.secondaryBackground)
                        .frame(height: 200)

                    VStack(spacing: 8) {
                        Image(systemName: "map")
                            .font(.largeTitle)
                            .foregroundColor(AppColors.primaryGold)
                        Text("Plattegrond binnenkort beschikbaar")
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }

    // MARK: - Contact Content

    private var contactContent: some View {
        LazyVStack(spacing: 16) {
            // General contact
            contactCard(
                title: "Algemene Vragen",
                icon: "envelope.fill",
                value: FestivalInfo.contact.email,
                action: "mailto:\(FestivalInfo.contact.email)"
            )

            contactCard(
                title: "Telefoon",
                icon: "phone.fill",
                value: FestivalInfo.contact.phone,
                action: "tel:\(FestivalInfo.contact.phone.replacingOccurrences(of: " ", with: ""))"
            )

            contactCard(
                title: "Website",
                icon: "globe",
                value: FestivalInfo.contact.website,
                action: FestivalInfo.contact.website
            )

            // Social media
            VStack(alignment: .leading, spacing: 12) {
                Text("Volg Ons")
                    .font(.headline)
                    .padding(.horizontal)

                HStack(spacing: 20) {
                    socialButton(name: "Instagram", icon: "camera.fill", handle: FestivalInfo.contact.instagram, url: FestivalInfo.contact.instagramURL)
                    socialButton(name: "Facebook", icon: "hand.thumbsup.fill", handle: FestivalInfo.contact.facebook, url: FestivalInfo.contact.facebookURL)
                }
                .padding(.horizontal)
            }


        }
        .padding(.vertical)
    }

    // MARK: - Helper Views

    private func infoCard(title: String, icon: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundColor(AppColors.primaryGold)

            Text(content)
                .font(.body)
                .foregroundColor(AppColors.textPrimary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppColors.secondaryBackground)
                .cornerRadius(12)
        }
        .padding(.horizontal)
    }

    private func contactCard(title: String, icon: String, value: String, action: String) -> some View {
        Button {
            if let url = URL(string: action) {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(AppColors.primaryGold)
                    .frame(width: 30)

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Text(value)
                        .font(.body)
                        .foregroundColor(AppColors.textPrimary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding()
            .background(AppColors.secondaryBackground)
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }

    private func socialButton(name: String, icon: String, handle: String, url: String) -> some View {
        Button {
            if let linkURL = URL(string: url) {
                UIApplication.shared.open(linkURL)
            }
        } label: {
            VStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(AppColors.primaryGold)
                    .frame(width: 50, height: 50)
                    .background(AppColors.secondaryBackground)
                    .cornerRadius(25)

                Text(handle)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}

// MARK: - Info Section Enum

enum InfoSection: String, CaseIterable, Identifiable {
    case faq = "FAQ"
    case venue = "Locatie"
    case contact = "Contact"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .faq: return "questionmark.circle"
        case .venue: return "mappin.circle"
        case .contact: return "phone.circle"
        }
    }
}

// MARK: - FAQ Item View

struct FAQItemView: View {
    let item: FAQItem
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack {
                    Text(item.question)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(AppColors.primaryGold)
                }
                .padding()
                .background(AppColors.secondaryBackground)
            }

            if isExpanded {
                Text(item.answer)
                    .font(.body)
                    .foregroundColor(AppColors.textSecondary)
                    .padding()
                    .background(AppColors.tertiaryBackground)
            }
        }
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    InfoView()
}
