import Foundation
import Combine

final class AppCoordinator: ObservableObject {
    let appState: AppState
    private let jiggleEngine: JiggleEngine
    private let idleMonitor: IdleMonitor
    private var modeCancellable: AnyCancellable?

    init(appState: AppState = AppState()) {
        self.appState = appState
        self.jiggleEngine = JiggleEngine(appState: appState)
        self.idleMonitor = IdleMonitor(appState: appState)

        modeCancellable = appState.$mode.sink { [weak self] mode in
            self?.handle(mode: mode)
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
