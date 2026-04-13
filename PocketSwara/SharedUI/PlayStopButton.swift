import SwiftUI

struct PlayStopButton: View {
    let isPlaying: Bool
    let color: Color
    let action: () -> Void

    @State private var isPulsing = false

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color.gradient)
                    .frame(width: 80, height: 80)
                    .scaleEffect(isPlaying && isPulsing ? 1.08 : 1.0)
                    .shadow(color: color.opacity(0.4), radius: isPlaying ? 12 : 6)

                Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.white)
                    .offset(x: isPlaying ? 0 : 2)
            }
        }
        .buttonStyle(.plain)
        .onChange(of: isPlaying) { _, playing in
            if playing {
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            } else {
                withAnimation(.easeOut(duration: 0.2)) {
                    isPulsing = false
                }
            }
        }
    }
}
