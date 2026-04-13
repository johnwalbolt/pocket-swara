import SwiftUI

struct RagaDetailView: View {
    @Environment(AppState.self) private var appState
    let raga: Raga

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    if !raga.alternateNames.isEmpty {
                        Text("Also known as: \(raga.alternateNames.joined(separator: ", "))")
                            .font(Theme.captionFont)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 16) {
                        Label(raga.thaat, systemImage: "music.note.list")
                        Label(raga.timeOfDay, systemImage: "clock")
                    }
                    .font(Theme.captionFont)
                    .foregroundStyle(.secondary)
                }

                // Aroh
                VStack(alignment: .leading, spacing: 8) {
                    Text("Aroh (Ascending)")
                        .font(Theme.headlineFont)
                    SwaraSequenceView(swaras: raga.aroh, vadi: raga.vadi, samvadi: raga.samvadi)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cardCornerRadius))

                // Avroh
                VStack(alignment: .leading, spacing: 8) {
                    Text("Avroh (Descending)")
                        .font(Theme.headlineFont)
                    SwaraSequenceView(swaras: raga.avroh, vadi: raga.vadi, samvadi: raga.samvadi)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cardCornerRadius))

                // Key swaras
                HStack(spacing: 20) {
                    VStack {
                        Text("Vadi")
                            .font(Theme.captionFont)
                            .foregroundStyle(.secondary)
                        Text(raga.vadi.displayName)
                            .font(Theme.titleFont)
                            .foregroundStyle(Theme.swaraColor(for: raga.vadi))
                    }
                    VStack {
                        Text("Samvadi")
                            .font(Theme.captionFont)
                            .foregroundStyle(.secondary)
                        Text(raga.samvadi.displayName)
                            .font(Theme.titleFont)
                            .foregroundStyle(Theme.swaraColor(for: raga.samvadi))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cardCornerRadius))

                // Description
                Text(raga.description)
                    .font(Theme.bodyFont)
                    .foregroundStyle(.secondary)

                // Select button
                Button {
                    appState.selectedRaga = raga
                } label: {
                    Text(appState.selectedRaga?.id == raga.id ? "Currently Selected" : "Select This Raga")
                        .font(Theme.headlineFont)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                .fill(appState.selectedRaga?.id == raga.id ? Color.green : Theme.ragaColor)
                        )
                }
            }
            .padding()
        }
        .background(Theme.backgroundColor)
        .navigationTitle(raga.name)
    }
}

struct SwaraSequenceView: View {
    let swaras: [Swara]
    let vadi: Swara
    let samvadi: Swara

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 8) {
            ForEach(Array(swaras.enumerated()), id: \.offset) { _, swara in
                Text(swara.shortName)
                    .font(.system(.body, design: .rounded, weight: swara == vadi || swara == samvadi ? .bold : .regular))
                    .foregroundStyle(Theme.swaraColor(for: swara))
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Theme.swaraColor(for: swara).opacity(0.15))
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(
                                Theme.swaraColor(for: swara),
                                lineWidth: (swara == vadi || swara == samvadi) ? 2 : 0
                            )
                    )
            }
        }
    }
}
