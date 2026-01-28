import SwiftUI

/// About screen with app and festival information
struct AboutView: View {

    // MARK: - Body

    var body: some View {
        List {
            appInfoSection
            festivalSection
            linksSection
            legalSection
            creditsSection
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Sections

    private var appInfoSection: some View {
        Section {
            VStack(spacing: 16) {
                // App icon placeholder
                ZStack {
                    Circle()
                        .fill(AppColors.primaryDark)
                        .frame(width: 80, height: 80)

                    Image(systemName: "music.note.list")
                        .font(.system(size: 35))
                        .foregroundColor(AppColors.primaryGold)
                }

                Text("Iconic Festival")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Your official guide to Iconic Festival 2026")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
        }
    }

    private var festivalSection: some View {
        Section("Festival") {
            LabeledContent("Event") {
                Text(FestivalData.festivalName)
            }

            LabeledContent("Location") {
                Text(FestivalData.festivalLocation)
            }

            LabeledContent("Date") {
                Text(FestivalData.festivalDate)
            }

            Text(FestivalData.festivalDescription)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private var linksSection: some View {
        Section("Links") {
            if let websiteURL = URL(string: FestivalInfo.contact.website) {
                Link(destination: websiteURL) {
                    Label("Official Website", systemImage: "safari")
                }
            }

            if let instagramURL = URL(string: "https://instagram.com/iconicfestival") {
                Link(destination: instagramURL) {
                    Label("Instagram", systemImage: "camera")
                }
            }

            if let facebookURL = URL(string: "https://facebook.com/IconicFestivalNL") {
                Link(destination: facebookURL) {
                    Label("Facebook", systemImage: "hand.thumbsup")
                }
            }
        }
    }

    private var legalSection: some View {
        Section("Legal") {
            NavigationLink {
                LegalTextView(
                    title: "Privacy Policy",
                    text: privacyPolicyText
                )
            } label: {
                Label("Privacy Policy", systemImage: "hand.raised")
            }

            NavigationLink {
                LegalTextView(
                    title: "Terms of Service",
                    text: termsOfServiceText
                )
            } label: {
                Label("Terms of Service", systemImage: "doc.text")
            }
        }
    }

    private var creditsSection: some View {
        Section("Credits") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Developed with SwiftUI")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Text("Powered by Claude AI")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Text("© 2026 Iconic Festival")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Legal Text

    private var privacyPolicyText: String {
        """
        Privacy Policy

        Last updated: January 2026

        Iconic Festival ("we", "our", or "us") respects your privacy. This Privacy Policy explains how we collect, use, and protect your personal information when you use the Iconic Festival mobile application.

        INFORMATION WE COLLECT

        - Device information: Device type, operating system version
        - Usage data: App features used, interactions with the app
        - Location data: Only when explicitly permitted for festival navigation
        - Chat data: Conversations with our AI assistant (stored locally on device)

        HOW WE USE YOUR INFORMATION

        We use your information to:
        - Provide and improve the app experience
        - Send you notifications about performances (if enabled)
        - Personalize your festival experience

        DATA STORAGE

        - Chat messages are stored locally on your device
        - Favorite artists are stored locally on your device
        - We do not sell your personal information to third parties

        YOUR RIGHTS

        You have the right to:
        - Access your personal data
        - Delete your data (via Settings > Debug > Clear All Data)
        - Opt out of notifications

        CONTACT US

        For privacy-related inquiries:
        Email: privacy@iconicfestival.nl
        Website: \(FestivalInfo.contact.website)
        """
    }

    private var termsOfServiceText: String {
        """
        Terms of Service

        Last updated: January 2026

        By using the Iconic Festival mobile application, you agree to these Terms of Service.

        USE OF THE APP

        - The app is provided for informational purposes about Iconic Festival 2026
        - Timetable information may be subject to change
        - The AI assistant provides general information and may not always be accurate

        CONTENT

        - All content, including timetables and artist information, is owned by Iconic Festival
        - Do not reproduce or distribute content without permission

        LIMITATIONS

        - We are not responsible for any changes to the festival program
        - The app is provided "as is" without warranties
        - We are not liable for any damages arising from app use

        FESTIVAL ATTENDANCE

        - This app does not replace your festival ticket
        - Festival rules and regulations apply separately

        UPDATES

        We may update these terms from time to time. Continued use of the app constitutes acceptance of any changes.

        CONTACT

        For questions about these terms:
        Email: legal@iconicfestival.nl
        Website: \(FestivalInfo.contact.website)
        """
    }
}

// MARK: - Legal Text View

struct LegalTextView: View {
    let title: String
    let text: String

    var body: some View {
        ScrollView {
            Text(text)
                .padding()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AboutView()
    }
}
