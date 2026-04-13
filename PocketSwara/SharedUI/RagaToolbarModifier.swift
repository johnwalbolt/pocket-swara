import SwiftUI

struct RagaToolbarModifier: ViewModifier {
    @Environment(AppState.self) private var appState
    @State private var showingRagaSelector = false

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingRagaSelector = true
                    } label: {
                        Text("Ragas")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(appState.selectedRaga != nil ? .white : .white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(appState.selectedRaga != nil ? Theme.ragaColor : Color.gray.opacity(0.5))
                            )
                    }
                }
            }
            .sheet(isPresented: $showingRagaSelector) {
                NavigationStack {
                    RagaSelectorSheet()
                }
                .presentationDetents([.large])
            }
    }
}

extension View {
    func ragaToolbar() -> some View {
        modifier(RagaToolbarModifier())
    }
}

/// Sheet version of the raga selector with a dismiss button
struct RagaSelectorSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = RagaSelectorViewModel()

    var body: some View {
        List {
            if appState.selectedRaga != nil {
                Section {
                    Button(role: .destructive) {
                        appState.selectedRaga = nil
                        dismiss()
                    } label: {
                        Label("Clear Raga Filter", systemImage: "xmark.circle")
                    }
                }
            }

            Section("All Ragas") {
                ForEach(viewModel.filteredRagas) { raga in
                    Button {
                        appState.selectedRaga = raga
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(raga.name)
                                        .font(Theme.headlineFont)
                                        .foregroundStyle(.primary)
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
                            Spacer()
                        }
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search ragas...")
        .navigationTitle("Select Raga")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Done") { dismiss() }
            }
        }
    }
}
