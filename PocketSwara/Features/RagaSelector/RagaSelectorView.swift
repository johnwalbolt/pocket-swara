import SwiftUI

struct RagaSelectorView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = RagaSelectorViewModel()

    var body: some View {
        NavigationStack {
            List {
                if appState.selectedRaga != nil {
                    Section {
                        Button(role: .destructive) {
                            appState.selectedRaga = nil
                        } label: {
                            Label("Clear Raga Selection", systemImage: "xmark.circle")
                        }
                    }
                }

                Section("All Ragas") {
                    ForEach(viewModel.filteredRagas) { raga in
                        NavigationLink(destination: RagaDetailView(raga: raga)) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(raga.name)
                                        .font(Theme.headlineFont)
                                    if appState.selectedRaga?.id == raga.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(Theme.ragaColor)
                                    }
                                }
                                HStack(spacing: 12) {
                                    Text(raga.thaat)
                                        .font(Theme.captionFont)
                                        .foregroundStyle(.secondary)
                                    Text(raga.timeOfDay)
                                        .font(Theme.captionFont)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search ragas...")
            .background(Theme.backgroundColor)
            .navigationTitle("Ragas")
        }
    }
}

#Preview {
    RagaSelectorView()
        .environment(AppState())
}
