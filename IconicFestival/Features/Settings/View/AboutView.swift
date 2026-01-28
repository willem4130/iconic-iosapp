import SwiftUI

/// Over scherm met app en festival informatie
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
        .navigationTitle("Over")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Sections

    private var appInfoSection: some View {
        Section {
            VStack(spacing: 16) {
                // App logo
                Image("IconicLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)

                Text("Iconic Festival")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Jouw officiële gids voor Iconic Festival 2026")
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
            LabeledContent("Evenement") {
                Text(FestivalData.festivalName)
            }

            LabeledContent("Locatie") {
                Text(FestivalData.festivalLocation)
            }

            LabeledContent("Datum") {
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
                    Label("Officiële Website", systemImage: "safari")
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
        Section("Juridisch") {
            NavigationLink {
                LegalTextView(
                    title: "Privacybeleid",
                    text: privacyPolicyText
                )
            } label: {
                Label("Privacybeleid", systemImage: "hand.raised")
            }

            NavigationLink {
                LegalTextView(
                    title: "Algemene Voorwaarden",
                    text: termsOfServiceText
                )
            } label: {
                Label("Algemene Voorwaarden", systemImage: "doc.text")
            }
        }
    }

    private var creditsSection: some View {
        Section("Credits") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Ontwikkeld met SwiftUI")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Text("Aangedreven door Claude AI")
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
        Privacybeleid

        Laatst bijgewerkt: januari 2026

        Iconic Festival ("wij", "ons" of "onze") respecteert uw privacy. Dit Privacybeleid legt uit hoe wij uw persoonlijke gegevens verzamelen, gebruiken en beschermen wanneer u de Iconic Festival mobiele applicatie gebruikt.

        INFORMATIE DIE WIJ VERZAMELEN

        - Apparaatinformatie: apparaattype, besturingssysteemversie
        - Gebruiksgegevens: app-functies gebruikt, interacties met de app
        - Locatiegegevens: alleen wanneer expliciet toegestaan voor festivalnavigatie
        - Chatgegevens: gesprekken met onze AI-assistent (lokaal opgeslagen op apparaat)

        HOE WIJ UW INFORMATIE GEBRUIKEN

        Wij gebruiken uw informatie om:
        - De app-ervaring te bieden en te verbeteren
        - U meldingen te sturen over optredens (indien ingeschakeld)
        - Uw festivalervaring te personaliseren

        GEGEVENSOPSLAG

        - Chatberichten worden lokaal op uw apparaat opgeslagen
        - Favoriete artiesten worden lokaal op uw apparaat opgeslagen
        - Wij verkopen uw persoonlijke informatie niet aan derden

        UW RECHTEN

        U heeft het recht om:
        - Toegang te krijgen tot uw persoonlijke gegevens
        - Uw gegevens te verwijderen (via Instellingen > Debug > Alle Data Wissen)
        - Af te melden voor meldingen

        NEEM CONTACT MET ONS OP

        Voor privacy-gerelateerde vragen:
        E-mail: privacy@iconicfestival.nl
        Website: \(FestivalInfo.contact.website)
        """
    }

    private var termsOfServiceText: String {
        """
        Algemene Voorwaarden

        Laatst bijgewerkt: januari 2026

        Door de Iconic Festival mobiele applicatie te gebruiken, gaat u akkoord met deze Algemene Voorwaarden.

        GEBRUIK VAN DE APP

        - De app wordt aangeboden voor informatiedoeleinden over Iconic Festival 2026
        - Programma-informatie kan aan verandering onderhevig zijn
        - De AI-assistent biedt algemene informatie en is mogelijk niet altijd nauwkeurig

        INHOUD

        - Alle inhoud, inclusief programma's en artiestinformatie, is eigendom van Iconic Festival
        - Reproduceer of verspreid geen inhoud zonder toestemming

        BEPERKINGEN

        - Wij zijn niet verantwoordelijk voor wijzigingen in het festivalprogramma
        - De app wordt "as is" aangeboden zonder garanties
        - Wij zijn niet aansprakelijk voor eventuele schade voortvloeiend uit app-gebruik

        FESTIVALBEZOEK

        - Deze app vervangt uw festivalticket niet
        - Festivalregels en -voorschriften gelden apart

        UPDATES

        Wij kunnen deze voorwaarden van tijd tot tijd bijwerken. Voortgezet gebruik van de app betekent acceptatie van eventuele wijzigingen.

        CONTACT

        Voor vragen over deze voorwaarden:
        E-mail: legal@iconicfestival.nl
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
