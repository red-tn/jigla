import Foundation

enum Weekday: Int, CaseIterable, Codable, Identifiable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    var id: Int { rawValue }

    // Calendar's weekdaySymbols arrays are 0-indexed Sunday-first, matching
    // rawValue - 1, and come localized for free.
    var singleLetterLabel: String {
        Calendar.current.veryShortWeekdaySymbols[rawValue - 1]
    }

    var fullName: String {
        Calendar.current.weekdaySymbols[rawValue - 1]
    }

    /// All seven days ordered for display, starting from the given
    /// `Calendar.firstWeekday` value (1 = Sunday ... 7 = Saturday).
    static func ordered(firstWeekday: Int) -> [Weekday] {
        (0..<7).compactMap { Weekday(rawValue: (firstWeekday - 1 + $0) % 7 + 1) }
    }
}
