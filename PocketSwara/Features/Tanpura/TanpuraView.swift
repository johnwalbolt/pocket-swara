import SwiftUI

struct TanpuraView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = TanpuraViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    SaPickerView()

                    // Drone mode selector
                    Picker("Mode", selection: $viewModel.droneMode) {
                        ForEach(DroneMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // Play/Stop button
                    PlayStopButton(
                        isPlaying: viewModel.isPlaying,
                        color: Theme.tanpuraColor
                    ) {
                        viewModel.toggle(baseSaFrequency: appState.baseSaFrequency)
                    }

                    // Tempo slider
                    VStack(spacing: 8) {
                        Text("Pluck Rate")
                            .font(Theme.headlineFont)
                        HStack {
                            Text("Slow")
                                .font(Theme.captionFont)
                            Slider(value: $viewModel.pluckRate, in: 0.3...1.5, step: 0.05)
                                .tint(Theme.tanpuraColor)
                            Text("Fast")
                                .font(Theme.captionFont)
                        }
                    }
                    .padding()
                    .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cardCornerRadius))

                    // String visualization
                    HStack(spacing: 16) {
                        ForEach(0..<4, id: \.self) { i in
                            StringVisualization(
                                index: i,
                                isPlaying: viewModel.isPlaying,
                                color: Theme.tanpuraColor
                            )
                        }
                    }
                    .frame(height: 120)
                    .padding()
                }
                .padding()
            }
            .background(Theme.backgroundColor)
            .navigationTitle("Tanpura")
            .ragaToolbar()
        }
    }
}

struct StringVisualization: View {
    let index: Int
    let isPlaying: Bool
    let color: Color
    @State private var vibrating = false

    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(color.opacity(isPlaying ? 0.8 : 0.3))
            .frame(width: 4, height: 120)
            .offset(x: vibrating ? CGFloat.random(in: -2...2) : 0)
            .animation(
                isPlaying
                    ? .linear(duration: 0.05).repeatForever(autoreverses: true).delay(Double(index) * 0.1)
                    : .default,
                value: vibrating
            )
            .onChange(of: isPlaying) { _, playing in
                vibrating = playing
            }
    }
}

#Preview {
    TanpuraView()
        .environment(AppState())
}
