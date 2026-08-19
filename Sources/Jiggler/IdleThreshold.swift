import Foundation

enum IdleThreshold {
    static func shouldZenJiggle(idleSeconds: Double, sleepThresholdSeconds: Double, safetyMarginSeconds: Double = 15) -> Bool {
        idleSeconds >= (sleepThresholdSeconds - safetyMarginSeconds)
    }
}
