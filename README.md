# Jiggler

A lightweight macOS menu bar app that keeps your Mac awake by periodically
nudging the mouse cursor.

## Requirements

- macOS 13 Ventura or later
- Xcode 14+ (or Xcode Command Line Tools) with Swift 5.9+

## Build & run

    swift build
    swift run

Or open this folder in Xcode (File > Open... and select this folder —
Xcode reads `Package.swift` directly) and press Run.

## Run tests

    swift test

## First launch

The first time you switch to Continuous or Zen mode (or hit "Jiggle Now"),
macOS needs Accessibility permission to let Jiggler move the cursor. Grant it
in System Settings > Privacy & Security > Accessibility, then try again.

## Modes

- **Off** — does nothing.
- **Continuous** — jiggles the mouse on a random interval within your
  configured Min/Max range (1-5 minutes), gated by the optional schedule.
- **Zen** — stays silent while you're active; jiggles once, right before
  your configured idle threshold, only to prevent sleep/screensaver.
- **Jiggle Now** — an immediate one-off jiggle, ignoring mode and schedule.

## Settings

- **Spacing** — how far (in pixels) the cursor moves for each jiggle.
- **Schedule** — optionally restrict Continuous/Zen jiggling to specific
  days and an hour range (e.g. weekdays 9-17). Disabled by default, meaning
  jiggling is allowed at any time. "Jiggle Now" always ignores the schedule.
