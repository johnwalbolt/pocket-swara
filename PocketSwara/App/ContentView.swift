import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TanpuraView()
                .tabItem {
                    Label("Tanpura", systemImage: "music.note")
                }

            ShrutiBoxView()
                .tabItem {
                    Label("Shruti", systemImage: "rectangle.grid.3x2.fill")
                }

            HarmoniumView()
                .tabItem {
                    Label("Harmonium", systemImage: "pianokeys")
                }

            ReferenceTonesView()
                .tabItem {
                    Label("Swaras", systemImage: "waveform")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(Theme.tanpuraColor)
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}
