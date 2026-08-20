import Foundation
import CoreGraphics

final class IdleMonitor {
    private let appState: AppState
    private var timer: Timer?
    private let pollingIntervalSeconds: TimeInterval = 5

    init(appState: AppState) {
        self.appState = appState
    }

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: pollingIntervalSeconds, repeats: true) { [weak self] _ in
            self?.checkIdle()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func checkIdle() {
        // HIDIdleTime counts ALL input (keyboard included); the old
        // .mouseMoved-only counter made Zen jiggle mid-typing. Fall back to
        // the mouse counter only if the IOKit read fails.
        let idleSeconds = SystemIdleTime.seconds()
            ?? CGEventSource.secondsSinceLastEventType(.combinedSessionState, eventType: .mouseMoved)
        let fires = JiggleDecision.shouldFireZenJiggle(
            mode: appState.mode,
            schedule: appState.schedule,
            idleSeconds: idleSeconds,
            sleepThresholdSeconds: appState.zenSleepThresholdMinutes * 60,
            now: Date()
        )
        if fires {
            MouseJiggler.jiggle(spacingPixels: appState.spacingPixels)
        }
    }
}
