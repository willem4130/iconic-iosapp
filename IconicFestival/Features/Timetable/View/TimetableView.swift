import SwiftUI

/// Main timetable view showing festival schedule
struct TimetableView: View {

    // MARK: - State

    @State private var selectedStage: Stage = .mainStage
    @State private var selectedPerformance: Performance?

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Stage selector
                stagePicker

                // Performance list
                performanceList
            }
            .background(AppColors.background)
            .navigationTitle("Timetable")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedPerformance) { performance in
                PerformanceDetailSheet(performance: performance)
            }
        }
    }

    // MARK: - Stage Picker

    private var stagePicker: some View {
        Picker("Stage", selection: $selectedStage) {
            ForEach(Stage.allCases) { stage in
                Text(stage.rawValue).tag(stage)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .background(AppColors.primaryDark)
    }

    // MARK: - Performance List

    private var performanceList: some View {
        let performances = FestivalData.performancesByStage()[selectedStage] ?? []
        let sortedPerformances = performances.sorted { $0.startTime < $1.startTime }

        return ScrollView {
            LazyVStack(spacing: 12) {
                // Stage info header
                stageInfoHeader

                ForEach(sortedPerformances) { performance in
                    PerformanceCard(performance: performance)
                        .onTapGesture {
                            selectedPerformance = performance
                        }
                }
            }
            .padding()
        }
    }

    // MARK: - Stage Info Header

    private var stageInfoHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(selectedStage.rawValue)
                    .font(.headline)
                    .foregroundColor(stageColor)

                Text("\(selectedStage.capacity) capacity • \(selectedStage.location)")
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }

            Spacer()

            Image(systemName: "music.note.house.fill")
                .font(.title2)
                .foregroundColor(stageColor)
        }
        .padding()
        .background(stageColor.opacity(0.1))
        .cornerRadius(12)
    }

    private var stageColor: Color {
        selectedStage == .mainStage ? AppColors.stageMain : AppColors.stageTheater
    }
}

// MARK: - Performance Card

struct PerformanceCard: View {
    let performance: Performance

    private var stageColor: Color {
        performance.stage == .mainStage ? AppColors.stageMain : AppColors.stageTheater
    }

    var body: some View {
        HStack(spacing: 16) {
            // Time column
            VStack(alignment: .center, spacing: 2) {
                Text(timeString(performance.startTime))
                    .font(.headline)
                    .fontWeight(.bold)

                Rectangle()
                    .fill(stageColor)
                    .frame(width: 2, height: 20)

                Text(timeString(performance.endTime))
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
            }
            .frame(width: 60)

            // Artist info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(performance.artist.name)
                        .font(.headline)
                        .fontWeight(.semibold)

                    if performance.isHeadliner {
                        Text("HEADLINER")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(AppColors.primaryGold)
                            .cornerRadius(4)
                    }
                }

                if let tribute = performance.artist.tributeTo {
                    Text("Tribute to \(tribute)")
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                }

                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text("\(performance.durationMinutes) min")
                        .font(.caption)

                    Spacer()

                    Text(performance.artist.genre)
                        .font(.caption)
                        .foregroundColor(stageColor)
                }
                .foregroundColor(AppColors.textTertiary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.textTertiary)
        }
        .padding()
        .background(AppColors.secondaryBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(stageColor.opacity(0.3), lineWidth: 1)
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
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .center, spacing: 12) {
            // Placeholder artist image
            ZStack {
                Circle()
                    .fill(stageColor.opacity(0.2))
                    .frame(width: 120, height: 120)

                Image(systemName: "music.mic")
                    .font(.system(size: 50))
                    .foregroundColor(stageColor)
            }

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

            Text(performance.artist.genre)
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var timeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Performance Time", systemImage: "clock.fill")
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
                    Text("End")
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

            Text("\(performance.durationMinutes) minutes")
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("About", systemImage: "info.circle.fill")
                .font(.headline)
                .foregroundColor(stageColor)

            if let tribute = performance.artist.tributeTo {
                Text("Tribute to \(tribute)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.primaryGold)
            }

            Text(performance.artist.description)
                .font(.body)
                .foregroundColor(AppColors.textPrimary)
        }
    }

    private var stageSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Stage", systemImage: "music.note.house.fill")
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

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Capacity")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Text("\(performance.stage.capacity)")
                        .font(.headline)
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
