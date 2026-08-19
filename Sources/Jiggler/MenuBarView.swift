import SwiftUI

struct MenuBarView: View {
    @ObservedObject var appState: AppState
    @State private var showingPermissionAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Mode", selection: $appState.mode) {
                Text("Off").tag(JiggleMode.off)
                Text("Continuous").tag(JiggleMode.continuous)
                Text("Zen").tag(JiggleMode.zen)
            }
            .pickerStyle(.segmented)
            .onChange(of: appState.mode) { newMode in
                if newMode != .off && !AccessibilityPermission.isTrusted() {
                    showingPermissionAlert = true
                }
            }

            Button("Jiggle Now") {
                triggerManualJiggle()
            }

            Divider()

            VStack(alignment: .leading) {
                Text("Interval: \(Int(appState.minIntervalMinutes))–\(Int(appState.maxIntervalMinutes)) min")
                    .font(.caption)
                HStack {
                    Text("Min").font(.caption2)
                    Slider(value: $appState.minIntervalMinutes, in: 1...5, step: 1)
                        .onChange(of: appState.minIntervalMinutes) { newValue in
                            if appState.maxIntervalMinutes < newValue {
                                appState.maxIntervalMinutes = newValue
                            }
                        }
                }
                HStack {
                    Text("Max").font(.caption2)
                    Slider(value: $appState.maxIntervalMinutes, in: 1...5, step: 1)
                        .onChange(of: appState.maxIntervalMinutes) { newValue in
                            if appState.minIntervalMinutes > newValue {
                                appState.minIntervalMinutes = newValue
                            }
                        }
                }
            }

            VStack(alignment: .leading) {
                Text("Spacing: \(Int(appState.spacingPixels)) px")
                    .font(.caption)
                Slider(value: $appState.spacingPixels, in: 1...50, step: 1)
            }

            if appState.mode == .zen {
                VStack(alignment: .leading) {
                    Text("Prevent sleep after: \(Int(appState.zenSleepThresholdMinutes)) min idle")
                        .font(.caption)
                    Slider(value: $appState.zenSleepThresholdMinutes, in: 1...30, step: 1)
                }
            }

            Divider()

            ScheduleEditorView(schedule: $appState.schedule)

            Divider()

            Button("Quit Jiggler") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
        .frame(width: 260)
        .alert("Accessibility Permission Required", isPresented: $showingPermissionAlert) {
            Button("Open System Settings") { AccessibilityPermission.openSystemSettings() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Jiggler needs Accessibility permission to move the cursor. Grant access in System Settings, then try again.")
        }
    }

    private func triggerManualJiggle() {
        if AccessibilityPermission.isTrusted() {
            MouseJiggler.jiggle(spacingPixels: appState.spacingPixels)
        } else {
            showingPermissionAlert = true
        }
    }
}
