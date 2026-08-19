import Foundation

struct ScheduleConfig: Codable, Equatable {
    var isEnabled: Bool
    var activeDays: Set<Weekday>
    var startHour: Int
    var startMinute: Int
    var endHour: Int
    var endMinute: Int

    static let `default` = ScheduleConfig(
        isEnabled: false,
        activeDays: Set(Weekday.allCases),
        startHour: 9,
        startMinute: 0,
        endHour: 17,
        endMinute: 0
    )
}
