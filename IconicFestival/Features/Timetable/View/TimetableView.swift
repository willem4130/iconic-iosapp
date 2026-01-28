import SwiftUI

/// Timetable weergave met festival programma
struct TimetableView: View {

    // MARK: - State

    @State private var selectedPerformance: Performance?

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Logo header
                logoHeader

                // Timetable
                integraalTwoColumnView
            }
            .background(AppColors.background)
            .navigationBarHidden(true)
            .sheet(item: $selectedPerformance) { performance in
                PerformanceDetailSheet(performance: performance)
            }
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

    // MARK: - Timetable View (Time-Aligned Grid)

    /// Height per minute in points (ultra-compact: 1.2, was 4.0)
    private let minuteHeight: CGFloat = 1.2

    private var integraalTwoColumnView: some View {
        let mainStagePerformances = (FestivalData.performancesByStage()[.mainStage] ?? []).sorted { $0.startTime < $1.startTime }
        let theaterPerformances = (FestivalData.performancesByStage()[.theater] ?? []).sorted { $0.startTime < $1.startTime }

        // Calculate time range for the grid
        let allPerformances = mainStagePerformances + theaterPerformances
        guard let earliestStart = allPerformances.map({ $0.startTime }).min(),
              let latestEnd = allPerformances.map({ $0.endTime }).max() else {
            return AnyView(Text("Geen programma beschikbaar").foregroundColor(AppColors.textSecondary))
        }

        // Round to 15-minute boundaries
        let gridStart = roundToQuarter(earliestStart, roundDown: true)
        let gridEnd = roundToQuarter(latestEnd, roundDown: false)
        let totalMinutes = gridEnd.timeIntervalSince(gridStart) / 60
        let totalHeight = CGFloat(totalMinutes) * minuteHeight

        return AnyView(
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 12) {
                    // Header
                    integraalHeader

                    // Column headers
                    HStack(spacing: 8) {
                        // Time column spacer
                        Color.clear.frame(width: 44)

                        stageColumnHeader(stage: .mainStage)
                            .frame(maxWidth: .infinity)

                        stageColumnHeader(stage: .theater)
                            .frame(maxWidth: .infinity)
                    }

                    // Time-aligned grid
                    HStack(alignment: .top, spacing: 8) {
                        // Time labels column
                        timeLabelsColumn(gridStart: gridStart, gridEnd: gridEnd)
                            .frame(width: 44)

                        // Main Stage Column
                        ZStack(alignment: .top) {
                            // Grid lines
                            timeGridLines(gridStart: gridStart, gridEnd: gridEnd)

                            // Performance cards
                            ForEach(mainStagePerformances) { performance in
                                timeAlignedCard(performance: performance, gridStart: gridStart)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: totalHeight)

                        // Openluchttheater Column
                        ZStack(alignment: .top) {
                            // Grid lines
                            timeGridLines(gridStart: gridStart, gridEnd: gridEnd)

                            // Performance cards
                            ForEach(theaterPerformances) { performance in
                                timeAlignedCard(performance: performance, gridStart: gridStart)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: totalHeight)
                    }
                }
                .padding()
            }
            .scrollIndicators(.visible)
        )
    }

    // MARK: - Time Grid Helpers

    private func roundToQuarter(_ date: Date, roundDown: Bool) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let minute = components.minute ?? 0
        let roundedMinute: Int

        if roundDown {
            roundedMinute = (minute / 15) * 15
        } else {
            roundedMinute = ((minute + 14) / 15) * 15
        }

        var newComponents = components
        newComponents.minute = roundedMinute % 60
        if roundedMinute >= 60 {
            newComponents.hour = (components.hour ?? 0) + 1
        }

        return calendar.date(from: newComponents) ?? date
    }

    private func timeLabelsColumn(gridStart: Date, gridEnd: Date) -> some View {
        let calendar = Calendar.current
        var labels: [(date: Date, label: String)] = []
        var current = gridStart

        while current <= gridEnd {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            labels.append((date: current, label: formatter.string(from: current)))
            current = calendar.date(byAdding: .minute, value: 15, to: current) ?? current
        }

        let totalMinutes = gridEnd.timeIntervalSince(gridStart) / 60
        let totalHeight = CGFloat(totalMinutes) * minuteHeight

        return ZStack(alignment: .topLeading) {
            ForEach(labels.indices, id: \.self) { index in
                let label = labels[index]
                let offsetMinutes = label.date.timeIntervalSince(gridStart) / 60
                let yOffset = CGFloat(offsetMinutes) * minuteHeight

                Text(label.label)
                    .font(.caption2)
                    .foregroundColor(AppColors.textTertiary)
                    .offset(y: yOffset - 6) // Center on the grid line
            }
        }
        .frame(height: totalHeight, alignment: .topLeading)
    }

    private func timeGridLines(gridStart: Date, gridEnd: Date) -> some View {
        let calendar = Calendar.current
        var lines: [Date] = []
        var current = gridStart

        while current <= gridEnd {
            lines.append(current)
            current = calendar.date(byAdding: .minute, value: 15, to: current) ?? current
        }

        let totalMinutes = gridEnd.timeIntervalSince(gridStart) / 60
        let totalHeight = CGFloat(totalMinutes) * minuteHeight

        return ZStack(alignment: .topLeading) {
            ForEach(lines.indices, id: \.self) { index in
                let lineDate = lines[index]
                let offsetMinutes = lineDate.timeIntervalSince(gridStart) / 60
                let yOffset = CGFloat(offsetMinutes) * minuteHeight

                // Determine if this is an hour line (bold) or quarter line (subtle)
                let calendar = Calendar.current
                let minute = calendar.component(.minute, from: lineDate)
                let isHourLine = minute == 0

                Rectangle()
                    .fill(isHourLine ? AppColors.textTertiary.opacity(0.3) : AppColors.textTertiary.opacity(0.1))
                    .frame(height: isHourLine ? 1 : 0.5)
                    .offset(y: yOffset)
            }
        }
        .frame(height: totalHeight, alignment: .topLeading)
    }

    private func timeAlignedCard(performance: Performance, gridStart: Date) -> some View {
        let offsetMinutes = performance.startTime.timeIntervalSince(gridStart) / 60
        let yOffset = CGFloat(offsetMinutes) * minuteHeight
        let cardHeight = CGFloat(performance.durationMinutes) * minuteHeight

        return CompactPerformanceCard(performance: performance, height: cardHeight)
            .offset(y: yOffset)
            .onTapGesture {
                selectedPerformance = performance
            }
    }

    // MARK: - Stage Column Header

    private func stageColumnHeader(stage: Stage) -> some View {
        VStack(spacing: 4) {
            Text(stage.rawValue)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(stage == .mainStage ? AppColors.stageMain : AppColors.stageTheater)

            Rectangle()
                .fill(stage == .mainStage ? AppColors.stageMain : AppColors.stageTheater)
                .frame(height: 2)
        }
        .padding(.bottom, 4)
    }

    // MARK: - Timetable Header

    private var integraalHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Timetable")
                    .font(.headline)
                    .foregroundColor(AppColors.primaryGold)

                Text("Beide podia op tijdvolgorde")
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }

            Spacer()

            Image(systemName: "music.note.list")
                .font(.title2)
                .foregroundColor(AppColors.primaryGold)
        }
        .padding()
        .background(AppColors.primaryGold.opacity(0.1))
        .cornerRadius(12)
    }

}

// MARK: - Performance Card (for timeline view)

struct CompactPerformanceCard: View {
    let performance: Performance
    var height: CGFloat? = nil

    private var stageColor: Color {
        performance.stage == .mainStage ? AppColors.stageMain : AppColors.stageTheater
    }

    /// Determine layout based on available height
    private var isCompact: Bool {
        guard let h = height else { return false }
        return h < 80
    }

    private var isVeryCompact: Bool {
        guard let h = height else { return false }
        return h < 50
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isVeryCompact ? 2 : (isCompact ? 4 : 6)) {
            // Time row
            HStack(spacing: 4) {
                Text(timeString(performance.startTime))
                    .font(isVeryCompact ? .caption2 : .caption)
                    .fontWeight(.bold)
                    .foregroundColor(stageColor)

                if !isVeryCompact {
                    Text("-")
                        .font(.caption2)
                        .foregroundColor(AppColors.textTertiary)

                    Text(timeString(performance.endTime))
                        .font(.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }

                Spacer()

                if performance.isHeadliner {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(AppColors.primaryGold)
                }
            }

            // Artist name
            Text(performance.artist.name)
                .font(isVeryCompact ? .caption : .subheadline)
                .fontWeight(.semibold)
                .lineLimit(isVeryCompact ? 1 : 2)
                .minimumScaleFactor(0.7)

            // Show additional info only if enough space
            if !isVeryCompact {
                // Tribute info
                if let tribute = performance.artist.tributeTo {
                    Text("Tribute aan \(tribute)")
                        .font(.caption2)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                }

            }

            Spacer(minLength: 0)
        }
        .padding(isVeryCompact ? 6 : (isCompact ? 8 : 10))
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: height)
        .background(stageColor.opacity(0.15))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(stageColor.opacity(0.5), lineWidth: 1)
        )
    }

    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Performance Detail Sheet

struct PerformanceDetailSheet: View {
    let performance: Performance
    @Environment(\.dismiss) private var dismiss

    private var stageColor: Color {
        performance.stage == .mainStage ? AppColors.stageMain : AppColors.stageTheater
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    headerSection

                    // Time info
                    timeSection

                    // Description
                    descriptionSection

                    // Social links
                    if performance.artist.socials.hasAny {
                        socialsSection
                    }

                    // Stage info
                    stageSection
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationTitle(performance.artist.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Klaar") { dismiss() }
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .center, spacing: 12) {
            // Artist image
            CachedAsyncImage(
                url: performance.artist.imageURL.flatMap { URL(string: $0) }
            ) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } placeholder: {
                ZStack {
                    Circle()
                        .fill(stageColor.opacity(0.2))
                        .frame(width: 120, height: 120)

                    Image(systemName: "music.mic")
                        .font(.system(size: 50))
                        .foregroundColor(stageColor)
                }
            }
            .frame(width: 120, height: 120)

            if performance.isHeadliner {
                Text("HEADLINER")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(AppColors.primaryGold)
                    .cornerRadius(6)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var timeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Speeltijd", systemImage: "clock.fill")
                .font(.headline)
                .foregroundColor(stageColor)

            HStack {
                VStack(alignment: .leading) {
                    Text("Start")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Text(timeString(performance.startTime))
                        .font(.title2)
                        .fontWeight(.bold)
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .foregroundColor(stageColor)

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Einde")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Text(timeString(performance.endTime))
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(AppColors.secondaryBackground)
            .cornerRadius(12)

            Text("\(performance.durationMinutes) minuten")
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Over", systemImage: "info.circle.fill")
                .font(.headline)
                .foregroundColor(stageColor)

            if let tribute = performance.artist.tributeTo {
                Text("Tribute aan \(tribute)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.primaryGold)
            }

            Text(performance.artist.description)
                .font(.body)
                .foregroundColor(AppColors.textPrimary)
        }
    }

    private var socialsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Links", systemImage: "link")
                .font(.headline)
                .foregroundColor(stageColor)

            HStack(spacing: 16) {
                if let website = performance.artist.socials.website,
                   let url = URL(string: website) {
                    Link(destination: url) {
                        socialIcon(systemName: "globe", label: "Website")
                    }
                }
                if let instagram = performance.artist.socials.instagram,
                   let url = URL(string: instagram) {
                    Link(destination: url) {
                        socialIcon(systemName: "camera.fill", label: "Instagram")
                    }
                }
                if let facebook = performance.artist.socials.facebook,
                   let url = URL(string: facebook) {
                    Link(destination: url) {
                        socialIcon(systemName: "person.2.fill", label: "Facebook")
                    }
                }
                if let spotify = performance.artist.socials.spotify,
                   let url = URL(string: spotify) {
                    Link(destination: url) {
                        socialIcon(systemName: "headphones", label: "Spotify")
                    }
                }
                if let youtube = performance.artist.socials.youtube,
                   let url = URL(string: youtube) {
                    Link(destination: url) {
                        socialIcon(systemName: "play.rectangle.fill", label: "YouTube")
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.secondaryBackground)
            .cornerRadius(12)
        }
    }

    private func socialIcon(systemName: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: systemName)
                .font(.title3)
                .foregroundColor(stageColor)
            Text(label)
                .font(.caption2)
                .foregroundColor(AppColors.textSecondary)
        }
    }

    private var stageSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Podium", systemImage: "music.note.house.fill")
                .font(.headline)
                .foregroundColor(stageColor)

            HStack {
                VStack(alignment: .leading) {
                    Text(performance.stage.rawValue)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(performance.stage.location)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                }


            }
            .padding()
            .background(stageColor.opacity(0.1))
            .cornerRadius(12)
        }
    }

    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Preview

#Preview {
    TimetableView()
}
