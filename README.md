# Jigla

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
macOS needs Accessibility permission to let Jigla move the cursor. Grant it
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

## Installing as a real app

`swift run` is fine for development, but it doesn't produce a real icon or a
double-clickable app. To build and install one:

    ./Scripts/build-app.sh --install

This puts `Jigla.app` in `/Applications`. Launch it from there, grant it
Accessibility permission once, and it behaves like any installed app —
including the **Launch at login** toggle in its menu, which registers it to
start automatically when you log in (settings and mode are restored from the
previous session). The toggle requires the installed copy; it can't register
a bare `swift run` binary.

To build without installing:

    ./Scripts/build-app.sh

This builds a release binary, assembles `Jigla.app`, compiles
`Resources/AppIcon.iconset/` into `AppIcon.icns`, writes an `Info.plist`, and
ad-hoc signs the bundle (`codesign --sign -`). The result, `Jigla.app` in
the repo root, runs and shows its icon in Finder/Dock/Activity Monitor on
this Mac.

Ad-hoc signing has no Apple Developer account requirement, but it's only
trusted on the Mac that built it — copying `Jigla.app` to another Mac will
trigger Gatekeeper's "unidentified developer" warning. Avoiding that on other
Macs requires a paid Apple Developer ID certificate plus notarizing the app
with Apple, which isn't set up here.

To change the icon artwork, edit and rerun `python Scripts/generate_icon.py`
(requires Pillow: `pip install pillow`) to regenerate
`Resources/AppIcon.iconset/`, then rerun `./Scripts/build-app.sh`. Or replace
the iconset with your own PNGs at the same filenames/sizes.
