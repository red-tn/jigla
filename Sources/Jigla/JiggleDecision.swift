import Foundation

enum JiggleDecision {
    static func shouldFireContinuousJiggle(mode: JiggleMode, schedule: ScheduleConfig, now: Date, calendar: Calendar = .current) -> Bool {
        mode == .continuous && ScheduleGate.isWithinSchedule(schedule, now: now, calendar: calendar)
    }

    static func shouldFireZenJiggle(
        mode: JiggleMode,
        schedule: ScheduleConfig,
        idleSeconds: Double,
        sleepThresholdSeconds: Double,
        now: Date,
        calendar: Calendar = .current
    ) -> Bool {
        guard mode == .zen else { return false }
        guard ScheduleGate.isWithinSchedule(schedule, now: now, calendar: calendar) else { return false }
        return IdleThreshold.shouldZenJiggle(idleSeconds: idleSeconds, sleepThresholdSeconds: sleepThresholdSeconds)
    }
}
