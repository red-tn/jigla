import Foundation
import Combine

final class JiggleEngine {
    private let appState: AppState
    private var timerCancellable: AnyCancellable?

    init(appState: AppState) {
        self.appState = appState
    }

    func start() {
        scheduleNext()
    }

    func stop() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func scheduleNext() {
        let interval = IntervalRandomizer.randomInterval(
            minMinutes: appState.minIntervalMinutes,
            maxMinutes: appState.maxIntervalMinutes
        )
        timerCancellable = Just(())
            .delay(for: .seconds(interval), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.fireIfAllowed() }
    }

    private func fireIfAllowed() {
        if JiggleDecision.shouldFireContinuousJiggle(mode: appState.mode, schedule: appState.schedule, now: Date()) {
            MouseJiggler.jiggle(spacingPixels: appState.spacingPixels)
        }
        scheduleNext()
    }
}
