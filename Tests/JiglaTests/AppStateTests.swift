import XCTest
@testable import Jigla

final class AppStateTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "JiglaTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    func test_defaultsWhenNoStoredValues() {
        let state = AppState(defaults: defaults)
        XCTAssertEqual(state.mode, .off)
        XCTAssertEqual(state.minIntervalMinutes, 1.0)
        XCTAssertEqual(state.maxIntervalMinutes, 5.0)
        XCTAssertEqual(state.spacingPixels, 5.0)
        XCTAssertEqual(state.zenSleepThresholdMinutes, 10.0)
        XCTAssertEqual(state.schedule, ScheduleConfig.default)
    }

    func test_persistsScalarSettingsAcrossInstances() {
        let first = AppState(defaults: defaults)
        first.mode = .zen
        first.spacingPixels = 12.0
        first.minIntervalMinutes = 2.0
        first.maxIntervalMinutes = 4.0
        first.zenSleepThresholdMinutes = 20.0

        let second = AppState(defaults: defaults)
        XCTAssertEqual(second.mode, .zen)
        XCTAssertEqual(second.spacingPixels, 12.0)
        XCTAssertEqual(second.minIntervalMinutes, 2.0)
        XCTAssertEqual(second.maxIntervalMinutes, 4.0)
        XCTAssertEqual(second.zenSleepThresholdMinutes, 20.0)
    }

    func test_persistsScheduleAcrossInstances() {
        let first = AppState(defaults: defaults)
        var newSchedule = ScheduleConfig.default
        newSchedule.isEnabled = true
        newSchedule.startHour = 8
        newSchedule.activeDays = [.monday, .tuesday]
        first.schedule = newSchedule

        let second = AppState(defaults: defaults)
        XCTAssertEqual(second.schedule, newSchedule)
    }
}
