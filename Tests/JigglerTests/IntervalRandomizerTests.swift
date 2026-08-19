import XCTest
@testable import Jiggler

final class IntervalRandomizerTests: XCTestCase {
    func test_randomInterval_isAlwaysWithinRangeInSeconds() {
        for _ in 0..<1000 {
            let interval = IntervalRandomizer.randomInterval(minMinutes: 1, maxMinutes: 5)
            XCTAssertGreaterThanOrEqual(interval, 60)
            XCTAssertLessThanOrEqual(interval, 300)
        }
    }

    func test_randomInterval_withEqualMinMax_returnsExactValue() {
        let interval = IntervalRandomizer.randomInterval(minMinutes: 2, maxMinutes: 2)
        XCTAssertEqual(interval, 120, accuracy: 0.0001)
    }

    func test_randomInterval_respectsNarrowRange() {
        for _ in 0..<1000 {
            let interval = IntervalRandomizer.randomInterval(minMinutes: 3, maxMinutes: 4)
            XCTAssertGreaterThanOrEqual(interval, 180)
            XCTAssertLessThanOrEqual(interval, 240)
        }
    }
}
