import Foundation

enum IntervalRandomizer {
    static func randomInterval(minMinutes: Double, maxMinutes: Double) -> TimeInterval {
        precondition(minMinutes > 0 && maxMinutes >= minMinutes, "minMinutes must be > 0 and <= maxMinutes")
        let minSeconds = minMinutes * 60
        let maxSeconds = maxMinutes * 60
        return Double.random(in: minSeconds...maxSeconds)
    }
}
