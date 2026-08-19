import XCTest
@testable import Jiggler

final class JiggleDecisionTests: XCTestCase {
    private var utcCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }

    private func date(hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        // Wednesday 2024-01-03
        components.year = 2024
        components.month = 1
        components.day = 3
        components.hour = hour
        components.minute = minute
        return utcCalendar.date(from: components)!
    }

    func test_continuousMode_scheduleDisabled_fires() {
        var schedule = ScheduleConfig.default
        schedule.isEnabled = false
        XCTAssertTrue(JiggleDecision.shouldFireContinuousJiggle(mode: .continuous, schedule: schedule, now: date(hour: 3, minute: 0), calendar: utcCalendar))
    }

    func test_continuousMode_outsideSchedule_doesNotFire() {
        var schedule = ScheduleConfig.default
        schedule.isEnabled = true // default window is 9-17
        XCTAssertFalse(JiggleDecision.shouldFireContinuousJiggle(mode: .continuous, schedule: schedule, now: date(hour: 3, minute: 0), calendar: utcCalendar))
    }

    func test_offMode_neverFiresContinuous() {
        var schedule = ScheduleConfig.default
        schedule.isEnabled = false
        XCTAssertFalse(JiggleDecision.shouldFireContinuousJiggle(mode: .off, schedule: schedule, now: date(hour: 10, minute: 0), calendar: utcCalendar))
    }

    func test_zenMode_farFromIdleThreshold_doesNotFire() {
        var schedule = ScheduleConfig.default
        schedule.isEnabled = false
        let fires = JiggleDecision.shouldFireZenJiggle(
            mode: .zen, schedule: schedule, idleSeconds: 30, sleepThresholdSeconds: 600,
            now: date(hour: 10, minute: 0), calendar: utcCalendar
        )
        XCTAssertFalse(fires)
    }

    func test_zenMode_nearIdleThreshold_fires() {
        var schedule = ScheduleConfig.default
        schedule.isEnabled = false
        let fires = JiggleDecision.shouldFireZenJiggle(
            mode: .zen, schedule: schedule, idleSeconds: 590, sleepThresholdSeconds: 600,
            now: date(hour: 10, minute: 0), calendar: utcCalendar
        )
        XCTAssertTrue(fires)
    }

    func test_zenMode_outsideSchedule_doesNotFireEvenNearThreshold() {
        var schedule = ScheduleConfig.default
        schedule.isEnabled = true // default window is 9-17
        let fires = JiggleDecision.shouldFireZenJiggle(
            mode: .zen, schedule: schedule, idleSeconds: 590, sleepThresholdSeconds: 600,
            now: date(hour: 3, minute: 0), calendar: utcCalendar
        )
        XCTAssertFalse(fires)
    }

    func test_continuousMode_doesNotFireZen() {
        var schedule = ScheduleConfig.default
        schedule.isEnabled = false
        let fires = JiggleDecision.shouldFireZenJiggle(
            mode: .continuous, schedule: schedule, idleSeconds: 590, sleepThresholdSeconds: 600,
            now: date(hour: 10, minute: 0), calendar: utcCalendar
        )
        XCTAssertFalse(fires)
    }
}
