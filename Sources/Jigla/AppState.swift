import Foundation
import Combine

final class AppState: ObservableObject {
    private enum Keys {
        static let mode = "jigla.mode"
        static let minInterval = "jigla.minIntervalMinutes"
        static let maxInterval = "jigla.maxIntervalMinutes"
        static let spacing = "jigla.spacingPixels"
        static let zenThreshold = "jigla.zenSleepThresholdMinutes"
        static let schedule = "jigla.schedule"
    }

    private let defaults: UserDefaults

    @Published var mode: JiggleMode {
        didSet { defaults.set(mode.rawValue, forKey: Keys.mode) }
    }
    @Published var minIntervalMinutes: Double {
        didSet { defaults.set(minIntervalMinutes, forKey: Keys.minInterval) }
    }
    @Published var maxIntervalMinutes: Double {
        didSet { defaults.set(maxIntervalMinutes, forKey: Keys.maxInterval) }
    }
    @Published var spacingPixels: Double {
        didSet { defaults.set(spacingPixels, forKey: Keys.spacing) }
    }
    @Published var zenSleepThresholdMinutes: Double {
        didSet { defaults.set(zenSleepThresholdMinutes, forKey: Keys.zenThreshold) }
    }
    @Published var schedule: ScheduleConfig {
        didSet {
            if let encoded = try? JSONEncoder().encode(schedule) {
                defaults.set(encoded, forKey: Keys.schedule)
            }
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        self.mode = JiggleMode(rawValue: defaults.string(forKey: Keys.mode) ?? "") ?? .off
        self.minIntervalMinutes = defaults.object(forKey: Keys.minInterval) as? Double ?? 1.0
        self.maxIntervalMinutes = defaults.object(forKey: Keys.maxInterval) as? Double ?? 5.0
        self.spacingPixels = defaults.object(forKey: Keys.spacing) as? Double ?? 5.0
        self.zenSleepThresholdMinutes = defaults.object(forKey: Keys.zenThreshold) as? Double ?? 10.0

        if let data = defaults.data(forKey: Keys.schedule),
           let decoded = try? JSONDecoder().decode(ScheduleConfig.self, from: data) {
            self.schedule = decoded
        } else {
            self.schedule = .default
        }
    }
}
