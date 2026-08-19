# Jiggler — macOS Menu Bar App Design

## Summary

A lightweight, native macOS menu bar utility that keeps the system awake/active
by periodically nudging the mouse cursor. No Dock icon, no external
dependencies, built with SwiftUI's `MenuBarExtra` (macOS 13 Ventura+).

## Goals

- Live entirely in the menu bar (`LSUIElement`, no Dock icon, no main window).
- Modes: **Off**, **Continuous** (timed jiggle on a configurable interval),
  **Zen** (idle-aware — only jiggles right before the system would go idle),
  plus a one-off **Jiggle Now** manual trigger.
- Continuous mode: jiggle interval randomized within a user-configured range
  of 1–5 minutes; jiggle "spacing" (px distance the cursor moves) configurable.
- Weekly schedule: active-hours window (days + start/end time) gates whether
  Continuous/Zen jiggling is allowed to run. Manual "Jiggle Now" always fires
  immediately regardless of schedule.
- Zero third-party dependencies; small binary; minimal CPU/memory footprint.

## Non-goals

- No iOS/cross-platform support.
- No cloud sync, accounts, or telemetry.
- No App Store distribution/signing pipeline (can be added later if desired).
- Zen mode does not use IOKit power assertions to block sleep outright — it
  relies on the same mouse-jiggle mechanism as Continuous mode, just gated by
  idle time instead of a fixed timer.

## Architecture

Single-target SwiftUI app, macOS 13+, no external dependencies (AppKit,
SwiftUI, Combine, IOKit/CoreGraphics only).

### Components

- **`AppState`** (`ObservableObject`) — single source of truth: current mode
  (`off` / `continuous` / `zen`), jiggle interval range (1–5 min), jiggle
  spacing (px), and weekly schedule config. Persisted via `@AppStorage` /
  `UserDefaults`.
- **`JiggleEngine`** — owns the Combine-based timer for Continuous mode. On
  each fire (interval randomized within the configured range), posts a
  synthetic tiny mouse move-and-back via `CGEvent`, scaled by the spacing
  setting. Checks `ScheduleGate` before each jiggle.
- **`IdleMonitor`** — polls system idle time (`CGEventSource.secondsSinceLastEventType`)
  every ~5s. Used only in Zen mode: fires a single minimal jiggle only when
  idle time is about to reach the configured "prevent sleep after X min idle"
  threshold. Also checks `ScheduleGate`.
- **`ScheduleGate`** — pure function(s) taking the weekly schedule config and
  a `Date`, returning whether jiggling is currently allowed. No side effects,
  fully unit-testable.
- **`MenuBarView`** — the dropdown UI: mode picker (Off / Continuous / Zen),
  "Jiggle Now" button, sliders for interval range (1–5 min) and spacing (px),
  and a schedule editor (day toggles + start/end time pickers). The menu bar
  glyph changes to reflect current state (idle vs actively jiggling).
- **`StatusIconController`** — small helper that maps `AppState` to the
  correct SF Symbol / icon variant for the menu bar.

### Data flow

User changes a setting in `MenuBarView` → `AppState` updates → `JiggleEngine`
/ `IdleMonitor` observe the change (via Combine) and reconfigure their timers
accordingly. No networking, no background daemons or launch agents beyond the
app's own in-process timer — the app must be running for jiggling to occur.

### Permissions / error handling

Posting synthetic mouse events via `CGEvent` requires the app to be granted
Accessibility permission (System Settings → Privacy & Security →
Accessibility). On first jiggle attempt, if the permission check fails, show
an alert explaining why, with a button that opens System Settings directly to
that pane (via the `x-apple.systempreferences:` URL scheme).

### Persistence

All settings (mode, interval range, spacing, schedule) persist across
launches via `UserDefaults`/`@AppStorage`. The app relaunches into whatever
mode was last active (i.e. it does not force Off on relaunch).

## Testing

This project is being written on a Windows machine without Xcode, so it
cannot be compiled or run here — a Mac with Xcode is required to build,
launch, and manually exercise the UI and actual cursor movement.

To keep as much of the logic verifiable independent of manual UI testing,
`ScheduleGate`'s window-matching logic, the interval-randomization function,
and the idle-threshold check will be written as pure, dependency-free
functions with accompanying XCTest unit tests included in the Xcode project,
runnable via `Cmd+U` once the project is opened on a Mac.

## Open items for implementation

- Exact SF Symbol choices for the menu bar icon states (can be decided during
  implementation).
- Whether to request Accessibility permission proactively on first launch vs.
  lazily on first jiggle attempt (leaning lazy, to avoid an unnecessary
  permission prompt if the user never enables a jiggling mode).
