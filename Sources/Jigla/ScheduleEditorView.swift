import SwiftUI

struct ScheduleEditorView: View {
    @Binding var schedule: ScheduleConfig

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Toggle("Restrict to schedule", isOn: $schedule.isEnabled)

            if schedule.isEnabled {
                HStack(spacing: 6) {
                    ForEach(Weekday.allCases) { day in
                        DayToggleChip(
                            day: day,
                            isSelected: schedule.activeDays.contains(day),
                            toggle: { toggleDay(day) }
                        )
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

    private func toggleDay(_ day: Weekday) {
        if schedule.activeDays.contains(day) {
            schedule.activeDays.remove(day)
        } else {
            schedule.activeDays.insert(day)
        }
    }
}

private struct DayToggleChip: View {
    let day: Weekday
    let isSelected: Bool
    let toggle: () -> Void

    var body: some View {
        Button(action: toggle) {
            Text(day.singleLetterLabel)
                .font(.system(size: 12, weight: .semibold))
                .frame(width: 26, height: 26)
                .background(
                    Circle().fill(isSelected ? Color.accentColor : Color.secondary.opacity(0.15))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(day.fullName)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}
