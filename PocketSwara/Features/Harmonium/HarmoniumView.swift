import SwiftUI

struct HarmoniumView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = HarmoniumViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SaPickerView()
                    .padding()

                Spacer()

                // Keyboard
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(-12..<13, id: \.self) { offset in
                            let swaraIndex = ((offset % 12) + 12) % 12
                            let swara = Swara.allCases[swaraIndex]
                            let octaveOffset = offset < 0 ? -1 : (offset >= 12 ? 1 : 0)

                            HarmoniumKeyView(
                                swara: swara,
                                octaveOffset: octaveOffset,
                                isInRaga: appState.activeSwaras.contains(swara),
                                isPressed: viewModel.pressedKeys.contains(HarmoniumViewModel.KeyID(swara: swara, octave: octaveOffset))
                            ) {
                                viewModel.keyDown(swara: swara, octaveOffset: octaveOffset, baseSaFrequency: appState.baseSaFrequency)
                            } onRelease: {
                                viewModel.keyUp(swara: swara, octaveOffset: octaveOffset)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .background(Theme.backgroundColor)
            .navigationTitle("Harmonium")
            .ragaToolbar()
        }
    }
}

struct HarmoniumKeyView: View {
    let swara: Swara
    let octaveOffset: Int
    let isInRaga: Bool
    let isPressed: Bool
    let onPress: () -> Void
    let onRelease: () -> Void

    var body: some View {
        let isBlack = swara.isKomalOrTivra

        VStack(spacing: 4) {
            Text(swara.displayName)
                .font(.system(size: isBlack ? 10 : 12, weight: .semibold, design: .rounded))
                .foregroundStyle(isPressed ? .white : (isBlack ? .white : Theme.swaraColor(for: swara)))
        }
        .frame(width: isBlack ? 36 : 48, height: isBlack ? 140 : 200)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(keyColor(isBlack: isBlack))
                .shadow(color: Theme.swaraColor(for: swara).opacity(isPressed ? 0.5 : 0), radius: 8)
        )
        .opacity(isInRaga ? 1.0 : 0.3)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed { onPress() }
                }
                .onEnded { _ in
                    onRelease()
                }
        )
    }

    func keyColor(isBlack: Bool) -> Color {
        if isPressed {
            return Theme.swaraColor(for: swara)
        }
        return isBlack ? Color(white: 0.2) : Color.white
    }
}

#Preview {
    HarmoniumView()
        .environment(AppState())
}
