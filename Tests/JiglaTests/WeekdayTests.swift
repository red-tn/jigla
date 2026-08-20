import XCTest
@testable import Jigla

final class WeekdayTests: XCTestCase {
    func test_ordered_sundayFirst_matchesRawValueOrder() {
        let days = Weekday.ordered(firstWeekday: 1)
        XCTAssertEqual(days, [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday])
    }

    func test_ordered_mondayFirst_wrapsSundayToEnd() {
        let days = Weekday.ordered(firstWeekday: 2)
        XCTAssertEqual(days, [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
    }

    func test_ordered_saturdayFirst_wrapsCorrectly() {
        let days = Weekday.ordered(firstWeekday: 7)
        XCTAssertEqual(days, [.saturday, .sunday, .monday, .tuesday, .wednesday, .thursday, .friday])
    }

    func test_ordered_alwaysContainsAllSevenDays() {
        for firstWeekday in 1...7 {
            let days = Weekday.ordered(firstWeekday: firstWeekday)
            XCTAssertEqual(Set(days), Set(Weekday.allCases), "firstWeekday \(firstWeekday)")
            XCTAssertEqual(days.count, 7, "firstWeekday \(firstWeekday)")
        }
    }
}
