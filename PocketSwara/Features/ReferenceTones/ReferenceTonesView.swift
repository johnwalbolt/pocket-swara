import SwiftUI

struct ReferenceTonesView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = ReferenceTonesViewModel()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    SaPickerView()

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Swara.allCases) { swara in
                            let isInRaga = appState.activeSwaras.contains(swara)
                            let isPlaying = viewModel.currentSwara == swara

                            Button {
                                viewModel.toggleSwara(swara, baseSaFrequency: appState.baseSaFrequency)
                            } label: {
                                VStack(spacing: 6) {
                                    Text(swara.displayName)
                                        .font(Theme.titleFont)
                                        .foregroundStyle(isPlaying ? .white : Theme.swaraColor(for: swara))

                                    Text(String(format: "%.1f Hz", swara.frequency(baseSaFrequency: appState.baseSaFrequency)))
                                        .font(Theme.captionFont)
                                        .foregroundStyle(isPlaying ? .white.opacity(0.8) : .secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                                        .fill(isPlaying
                                              ? Theme.swaraColor(for: swara)
                                              : Theme.swaraColor(for: swara).opacity(0.12))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                                        .strokeBorder(Theme.swaraColor(for: swara), lineWidth: isPlaying ? 0 : 1.5)
                                )
                            }
                            .buttonStyle(.plain)
                            .opacity(isInRaga ? 1.0 : 0.25)
                            .scaleEffect(isPlaying ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3), value: isPlaying)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .background(Theme.backgroundColor)
            .navigationTitle("Swara Reference")
            .ragaToolbar()
        }
    }
}

#Preview {
    ReferenceTonesView()
        .environment(AppState())
}
