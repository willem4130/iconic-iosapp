import SwiftUI

/// Festival information view with FAQ, venue info, and contact details
struct InfoView: View {

    // MARK: - State

    @State private var selectedSection: InfoSection = .faq
    @State private var expandedFAQs: Set<UUID> = []
    @State private var searchText = ""

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Section picker
                sectionPicker

                // Content
                ScrollView {
                    switch selectedSection {
                    case .faq:
                        faqContent
                    case .venue:
                        venueContent
                    case .contact:
                        contactContent
                    }
                }
            }
            .background(AppColors.background)
            .navigationTitle("Festival Info")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Section Picker

    private var sectionPicker: some View {
        Picker("Section", selection: $selectedSection) {
            ForEach(InfoSection.allCases) { section in
                Label(section.rawValue, systemImage: section.icon)
                    .tag(section)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .background(AppColors.primaryDark)
    }

    // MARK: - FAQ Content

    private var faqContent: some View {
        LazyVStack(spacing: 16) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textTertiary)
                TextField("Search FAQ...", text: $searchText)
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
            // Address card
            infoCard(
                title: "Venue Address",
                icon: "mappin.circle.fill",
                content: FestivalInfo.venueAddress
            )

            // Opening hours
            infoCard(
                title: "Opening Hours",
                icon: "clock.fill",
                content: FestivalInfo.openingHours
            )

            // Public transport
            infoCard(
                title: "Public Transport",
                icon: "bus.fill",
                content: FestivalInfo.publicTransportInfo
            )

            // Parking
            infoCard(
                title: "Parking",
                icon: "car.fill",
                content: FestivalInfo.parkingInfo
            )

            // Map placeholder
            VStack(alignment: .leading, spacing: 8) {
                Label("Location", systemImage: "map.fill")
                    .font(.headline)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.secondaryBackground)
                        .frame(height: 200)

                    VStack(spacing: 8) {
                        Image(systemName: "map")
                            .font(.largeTitle)
                            .foregroundColor(AppColors.primaryGold)
                        Text("Map coming soon")
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
                title: "General Inquiries",
                icon: "envelope.fill",
                value: FestivalInfo.contact.email,
                action: "mailto:\(FestivalInfo.contact.email)"
            )

            contactCard(
                title: "Phone",
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
                Text("Follow Us")
                    .font(.headline)
                    .padding(.horizontal)

                HStack(spacing: 20) {
                    socialButton(name: "Instagram", icon: "camera.fill", handle: FestivalInfo.contact.instagram)
                    socialButton(name: "Facebook", icon: "hand.thumbsup.fill", handle: FestivalInfo.contact.facebook)
                }
                .padding(.horizontal)
            }

            // Emergency
            VStack(alignment: .leading, spacing: 8) {
                Label("Emergency", systemImage: "exclamationmark.triangle.fill")
                    .font(.headline)
                    .foregroundColor(AppColors.error)
                    .padding(.horizontal)

                Button {
                    if let url = URL(string: "tel:\(FestivalInfo.contact.emergencyPhone)") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Image(systemName: "phone.badge.waveform.fill")
                        Text("Emergency: \(FestivalInfo.contact.emergencyPhone)")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.error)
                    .cornerRadius(12)
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

    private func socialButton(name: String, icon: String, handle: String) -> some View {
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

// MARK: - Info Section Enum

enum InfoSection: String, CaseIterable, Identifiable {
    case faq = "FAQ"
    case venue = "Venue"
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
