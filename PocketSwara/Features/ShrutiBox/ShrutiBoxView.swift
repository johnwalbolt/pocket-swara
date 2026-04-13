import SwiftUI

struct ShrutiBoxView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = ShrutiBoxViewModel()

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
                            ShrutiSwaraCard(
                                swara: swara,
                                isActive: viewModel.activeSwaras.contains(swara),
                                isInRaga: appState.activeSwaras.contains(swara),
                                volume: viewModel.volumes[swara] ?? 0.7
                            ) {
                                viewModel.toggleSwara(swara, baseSaFrequency: appState.baseSaFrequency)
                            } onVolumeChange: { vol in
                                viewModel.setVolume(vol, for: swara)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .background(Theme.backgroundColor)
            .navigationTitle("Shruti Box")
            .ragaToolbar()
        }
    }
}

struct ShrutiSwaraCard: View {
    let swara: Swara
    let isActive: Bool
    let isInRaga: Bool
    let volume: Float
    let onToggle: () -> Void
    let onVolumeChange: (Float) -> Void

    var body: some View {
        VStack(spacing: 8) {
            Button(action: onToggle) {
                VStack(spacing: 4) {
                    Text(swara.displayName)
                        .font(Theme.headlineFont)
                        .foregroundStyle(isActive ? .white : Theme.swaraColor(for: swara))

                    Circle()
                        .fill(isActive ? Color.white : Color.clear)
                        .frame(width: 8, height: 8)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                        .fill(isActive ? Theme.swaraColor(for: swara) : Theme.swaraColor(for: swara).opacity(0.15))
                )
            }
            .buttonStyle(.plain)
            .opacity(isInRaga ? 1.0 : 0.3)

            if isActive {
                Slider(value: Binding(
                    get: { volume },
                    set: { onVolumeChange(Float($0)) }
                ), in: 0...1)
                .tint(Theme.swaraColor(for: swara))
                .frame(height: 20)
            }
        }
    }
}

#Preview {
    ShrutiBoxView()
        .environment(AppState())
}
