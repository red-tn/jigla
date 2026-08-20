import SwiftUI

@main
struct JiglaApp: App {
    @StateObject private var coordinator = AppCoordinator()

    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(appState: coordinator.appState)
        } label: {
            Image(systemName: StatusIconController.symbolName(
                for: coordinator.appState.mode,
                isActivelyJiggling: coordinator.appState.mode != .off
            ))
        }
        .menuBarExtraStyle(.window)
    }
}
