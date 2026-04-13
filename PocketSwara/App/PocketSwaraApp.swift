import SwiftUI

@main
struct PocketSwaraApp: App {
    @State private var appState = AppState()

    init() {
        AudioSessionManager.shared.configureForPlayback()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
    }
}
