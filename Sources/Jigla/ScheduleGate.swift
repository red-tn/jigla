import Foundation

enum ScheduleGate {
    /// Note: for an overnight window (start > end), both halves of the night
    /// are gated only by whether "today" (the calendar day `now` falls on)
    /// is in `activeDays` — the portion after midnight does not check
    /// yesterday's active-day flag separately. This matches the common case
    /// (e.g. every weekday overnight) but a single-day overnight window can
    /// behave slightly differently than expected right after midnight.
    static func isWithinSchedule(_ config: ScheduleConfig, now: Date, calendar: Calendar = .current) -> Bool {
        guard config.isEnabled else { return true }

        let weekdayNumber = calendar.component(.weekday, from: now)
        guard let today = Weekday(rawValue: weekdayNumber), config.activeDays.contains(today) else {
            return false
        }

        let nowMinutes = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)
        let startMinutes = config.startHour * 60 + config.startMinute
        let endMinutes = config.endHour * 60 + config.endMinute

        if startMinutes == endMinutes {
            return true
        } else if startMinutes < endMinutes {
            return nowMinutes >= startMinutes && nowMinutes < endMinutes
        } else {
            return nowMinutes >= startMinutes || nowMinutes < endMinutes
        }
    }
}
