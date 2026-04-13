import SwiftUI

struct SaPickerView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var state = appState
        HStack {
            Text("Base Sa")
                .font(Theme.headlineFont)
            Spacer()
            Picker("Base Sa", selection: $state.baseSaPitch) {
                ForEach(NotePitch.allNotes) { note in
                    Text(note.displayName).tag(note)
                }
            }
            .pickerStyle(.menu)
            .tint(Theme.tanpuraColor)

            Text(String(format: "%.1f Hz", appState.baseSaFrequency))
                .font(Theme.captionFont)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Theme.cardBackground, in: RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
    }
}
