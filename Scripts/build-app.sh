#!/bin/bash
# Builds Jigla.app: a proper macOS app bundle with an icon, ad-hoc signed.
#
# Must be run on macOS (uses iconutil and codesign, which don't exist
# elsewhere). Run from the repo root:
#
#   ./Scripts/build-app.sh
#
set -euo pipefail

BUNDLE_ID="com.jigla.app"
APP_NAME="Jigla"
VERSION="1.0.0"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

APP_BUNDLE="$REPO_ROOT/$APP_NAME.app"
ICONSET_DIR="$REPO_ROOT/Resources/AppIcon.iconset"

echo "==> Building release binary"
swift build -c release

BUILT_BINARY="$(swift build -c release --show-bin-path)/$APP_NAME"
if [ ! -f "$BUILT_BINARY" ]; then
    echo "error: expected binary not found at $BUILT_BINARY" >&2
    exit 1
fi

echo "==> Assembling $APP_NAME.app"
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS" "$APP_BUNDLE/Contents/Resources"
cp "$BUILT_BINARY" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"

echo "==> Compiling app icon"
if [ ! -d "$ICONSET_DIR" ]; then
    echo "error: $ICONSET_DIR not found. Run Scripts/generate_icon.py first (or supply your own iconset)." >&2
    exit 1
fi
iconutil -c icns "$ICONSET_DIR" -o "$APP_BUNDLE/Contents/Resources/AppIcon.icns"

echo "==> Writing Info.plist"
cat > "$APP_BUNDLE/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleDisplayName</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

echo "==> Ad-hoc signing"
codesign --deep --force --options runtime --sign - "$APP_BUNDLE"
codesign --verify --verbose "$APP_BUNDLE"

echo "==> Done: $APP_BUNDLE"
echo "This is ad-hoc signed (no Apple Developer ID). It will run fine on this"
echo "Mac. Copying it to another Mac will trigger an 'unidentified developer'"
echo "Gatekeeper warning unless you sign with a Developer ID and notarize it."
