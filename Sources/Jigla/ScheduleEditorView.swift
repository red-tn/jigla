import SwiftUI

struct ScheduleEditorView: View {
    @Binding var schedule: ScheduleConfig

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle("Restrict to schedule", isOn: $schedule.isEnabled)

            if schedule.isEnabled {
                HStack {
                    ForEach(Weekday.allCases) { day in
                        Toggle(day.shortLabel, isOn: Binding(
                            get: { schedule.activeDays.contains(day) },
                            set: { isOn in
                                if isOn {
                                    schedule.activeDays.insert(day)
                                } else {
                                    schedule.activeDays.remove(day)
                                }
                            }
                        ))
                        .toggleStyle(.button)
                        .font(.caption2)
                    }
                }

                Stepper(
                    "Start: \(String(format: "%02d:00", schedule.startHour))",
                    onIncrement: { schedule.startHour = (schedule.startHour + 1) % 24 },
                    onDecrement: { schedule.startHour = (schedule.startHour + 23) % 24 }
                )
                Stepper(
                    "End: \(String(format: "%02d:00", schedule.endHour))",
                    onIncrement: { schedule.endHour = (schedule.endHour + 1) % 24 },
                    onDecrement: { schedule.endHour = (schedule.endHour + 23) % 24 }
                )
            }
        }
    }
}
