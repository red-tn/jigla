import SwiftUI
import AppKit

struct ScheduleEditorView: View {
    @Binding var schedule: ScheduleConfig

    private let orderedDays = Weekday.ordered(firstWeekday: Calendar.current.firstWeekday)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Toggle("Restrict to schedule", isOn: $schedule.isEnabled)

            if schedule.isEnabled {
                HStack(spacing: 6) {
                    ForEach(orderedDays) { day in
                        Toggle(day.singleLetterLabel, isOn: binding(for: day))
                            .toggleStyle(DayChipToggleStyle())
                            .accessibilityLabel(day.fullName)
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

    private func binding(for day: Weekday) -> Binding<Bool> {
        Binding(
            get: { schedule.activeDays.contains(day) },
            set: { isOn in
                if isOn {
                    schedule.activeDays.insert(day)
                } else {
                    schedule.activeDays.remove(day)
                }
            }
        )
    }
}

private struct DayChipToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
                .font(.system(size: 12, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(width: 26, height: 26)
                .background(
                    Circle().fill(configuration.isOn ? Color.accentColor : Color.secondary.opacity(0.15))
                )
                .foregroundColor(configuration.isOn ? Self.selectedTextColor : .primary)
        }
        .buttonStyle(.plain)
    }

    // White text is unreadable on light accent colors (Yellow, Graphite in
    // light mode), so pick black/white by the accent's luminance the way
    // macOS does for its own accent-tinted selections.
    private static var selectedTextColor: Color {
        guard let accent = NSColor.controlAccentColor.usingColorSpace(.sRGB) else { return .white }
        let luminance = 0.299 * accent.redComponent + 0.587 * accent.greenComponent + 0.114 * accent.blueComponent
        return luminance > 0.65 ? .black : .white
    }
}
