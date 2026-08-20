import Foundation
import Combine

final class AppCoordinator: ObservableObject {
    let appState: AppState
    private let jiggleEngine: JiggleEngine
    private let idleMonitor: IdleMonitor
    private var modeCancellable: AnyCancellable?
    private var stateCancellable: AnyCancellable?
    private var intervalCancellable: AnyCancellable?

    init(appState: AppState = AppState()) {
        self.appState = appState
        self.jiggleEngine = JiggleEngine(appState: appState)
        self.idleMonitor = IdleMonitor(appState: appState)

        modeCancellable = appState.$mode.sink { [weak self] mode in
            self?.handle(mode: mode)
        }
        // The MenuBarExtra label observes this coordinator, not AppState, so
        // AppState changes must be re-published or the menu bar icon goes
        // stale when the mode changes.
        stateCancellable = appState.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        // A pending jiggle keeps its old delay, so without a restart an
        // interval change can take up to the old maximum to be honored.
        intervalCancellable = appState.$minIntervalMinutes
            .combineLatest(appState.$maxIntervalMinutes)
            .dropFirst()
            .removeDuplicates { $0 == $1 }
            .sink { [weak self] _ in
                guard let self, self.appState.mode == .continuous else { return }
                self.jiggleEngine.stop()
                self.jiggleEngine.start()
            }
    }

    private func handle(mode: JiggleMode) {
        jiggleEngine.stop()
        idleMonitor.stop()
        switch mode {
        case .off:
            break
        case .continuous:
            jiggleEngine.start()
        case .zen:
            idleMonitor.start()
        }
    }
}
