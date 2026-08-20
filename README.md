# Jigla

A lightweight macOS menu bar app that keeps your Mac awake by periodically
nudging the mouse cursor.

## Features

- **Menu bar only** — no Dock icon, no windows. The status icon reflects the
  current mode (hollow circle = Off, filled circle = Continuous,
  moon = Zen).
- **Three modes:**
  - **Off** — does nothing.
  - **Continuous** — jiggles the mouse on a random interval within your
    configured Min/Max range (1–5 minutes), gated by the optional schedule.
  - **Zen** — stays silent while you're active; jiggles once, right before
    your configured idle threshold (1–30 minutes), only to prevent
    sleep/screensaver.
- **Jiggle Now** — an immediate one-off jiggle from the menu, ignoring mode
  and schedule.
- **Spacing** — how far the cursor moves per jiggle (1–50 pixels).
- **Schedule** — optionally restrict Continuous/Zen jiggling to specific
  days of the week and a time range (e.g. weekdays 9:00–17:00). Disabled by
  default, meaning jiggling is allowed at any time.
- **Launch at login** — one toggle in the menu registers the app to start
  automatically when you log in (requires the installed copy, see below).
- **Persistent settings** — mode, intervals, spacing, threshold, and
  schedule are saved and restored across launches.

## Requirements

- macOS 13 Ventura or later
- Xcode 14+ (or Xcode Command Line Tools) with Swift 5.9+

## Install

1. **Get the tools** (skip if you already have Xcode):

       xcode-select --install

2. **Clone the repo:**

       git clone https://github.com/red-tn/jigla.git
       cd jigla

3. **Build and install:**

       ./Scripts/build-app.sh --install

   This builds a release binary, assembles `Jigla.app` with its icon and
   `Info.plist`, ad-hoc signs it, and copies it to `/Applications`
   (replacing any previous copy).

4. **Launch** `Jigla.app` from `/Applications` (Spotlight or Finder). It
   appears in the menu bar, not the Dock.

5. **Grant Accessibility permission.** The first time you switch to
   Continuous or Zen mode (or hit "Jiggle Now"), macOS needs Accessibility
   permission to let Jigla move the cursor. Grant it in
   System Settings > Privacy & Security > Accessibility, then try again.
   This only needs to be done once.

6. **(Optional)** Enable **Launch at login** in the menu so Jigla starts
   automatically when you log in, restoring your mode and settings from the
   previous session. The toggle requires the installed copy in
   `/Applications`; it can't register a bare `swift run` binary.

To build the app bundle without installing it, run the script with no flag:

    ./Scripts/build-app.sh

The result, `Jigla.app` in the repo root, runs and shows its icon in
Finder/Dock/Activity Monitor on this Mac.

### A note on signing

The build is ad-hoc signed (`codesign --sign -`), which has no Apple
Developer account requirement, but it's only trusted on the Mac that built
it — copying `Jigla.app` to another Mac will trigger Gatekeeper's
"unidentified developer" warning. Avoiding that on other Macs requires a
paid Apple Developer ID certificate plus notarizing the app with Apple,
which isn't set up here. The workaround: build it on each Mac.

## Development

Build and run without producing an app bundle:

    swift build
    swift run

Or open this folder in Xcode (File > Open... and select this folder —
Xcode reads `Package.swift` directly) and press Run.

Run the tests:

    swift test

To change the icon artwork, edit and rerun `python Scripts/generate_icon.py`
(requires Pillow: `pip install pillow`) to regenerate
`Resources/AppIcon.iconset/`, then rerun `./Scripts/build-app.sh`. Or replace
the iconset with your own PNGs at the same filenames/sizes.
