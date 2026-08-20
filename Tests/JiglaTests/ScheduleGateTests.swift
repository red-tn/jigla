import XCTest
@testable import Jigla

final class ScheduleGateTests: XCTestCase {
    private var utcCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }

    private func date(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return utcCalendar.date(from: components)!
    }

    func test_disabledSchedule_alwaysAllowed() {
        var config = ScheduleConfig.default
        config.isEnabled = false
        // Sunday, well outside the default 9-17 window
        let now = date(year: 2024, month: 1, day: 7, hour: 3, minute: 0)
        XCTAssertTrue(ScheduleGate.isWithinSchedule(config, now: now, calendar: utcCalendar))
    }

    func test_withinWeekdayWindow_allowed() {
        var config = ScheduleConfig.default
        config.isEnabled = true
        // Wednesday 2024-01-03 at 10:00
        let now = date(year: 2024, month: 1, day: 3, hour: 10, minute: 0)
        XCTAssertTrue(ScheduleGate.isWithinSchedule(config, now: now, calendar: utcCalendar))
    }

    func test_outsideWeekdayWindow_notAllowed() {
        var config = ScheduleConfig.default
        config.isEnabled = true
        // Wednesday 2024-01-03 at 20:00, after the default 17:00 end
        let now = date(year: 2024, month: 1, day: 3, hour: 20, minute: 0)
        XCTAssertFalse(ScheduleGate.isWithinSchedule(config, now: now, calendar: utcCalendar))
    }

    func test_dayNotActive_notAllowed() {
        var config = ScheduleConfig.default
        config.isEnabled = true
        config.activeDays = [.monday, .tuesday, .wednesday, .thursday, .friday]
        // Saturday 2024-01-06 at 10:00
        let now = date(year: 2024, month: 1, day: 6, hour: 10, minute: 0)
        XCTAssertFalse(ScheduleGate.isWithinSchedule(config, now: now, calendar: utcCalendar))
    }

    func test_overnightWindow_allowedAfterStart() {
        var config = ScheduleConfig.default
        config.isEnabled = true
        config.startHour = 22
        config.startMinute = 0
        config.endHour = 6
        config.endMinute = 0
        // Wednesday 2024-01-03 at 23:00
        let now = date(year: 2024, month: 1, day: 3, hour: 23, minute: 0)
        XCTAssertTrue(ScheduleGate.isWithinSchedule(config, now: now, calendar: utcCalendar))
    }

    func test_overnightWindow_allowedBeforeEnd() {
        var config = ScheduleConfig.default
        config.isEnabled = true
        config.startHour = 22
        config.startMinute = 0
        config.endHour = 6
        config.endMinute = 0
        // Wednesday 2024-01-03 at 02:00
        let now = date(year: 2024, month: 1, day: 3, hour: 2, minute: 0)
        XCTAssertTrue(ScheduleGate.isWithinSchedule(config, now: now, calendar: utcCalendar))
    }

    func test_overnightWindow_notAllowedMidday() {
        var config = ScheduleConfig.default
        config.isEnabled = true
        config.startHour = 22
        config.startMinute = 0
        config.endHour = 6
        config.endMinute = 0
        // Wednesday 2024-01-03 at 12:00
        let now = date(year: 2024, month: 1, day: 3, hour: 12, minute: 0)
        XCTAssertFalse(ScheduleGate.isWithinSchedule(config, now: now, calendar: utcCalendar))
    }
}
