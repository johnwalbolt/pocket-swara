import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            List {
                Section("Pitch") {
                    SaPickerView()
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }

                Section("Current Raga") {
                    if let raga = appState.selectedRaga {
                        HStack {
                            Text(raga.name)
                                .font(Theme.headlineFont)
                            Spacer()
                            Button("Clear") {
                                appState.selectedRaga = nil
                            }
                            .foregroundStyle(.red)
                        }
                    } else {
                        Text("No raga selected")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Build")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    VStack(spacing: 8) {
                        Text("Pocket Swara")
                            .font(Theme.titleFont)
                            .foregroundStyle(Theme.tanpuraColor)
                        Text("Your Indian music practice companion")
                            .font(Theme.captionFont)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Settings")
        }
    }


}

#Preview {
    SettingsView()
        .environment(AppState())
}
