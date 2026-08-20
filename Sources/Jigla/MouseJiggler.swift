import CoreGraphics

enum MouseJiggler {
    static func jiggle(spacingPixels: Double) {
        guard let currentLocation = CGEvent(source: nil)?.location else { return }
        let target = JiggleOffsetCalculator.jiggledPoint(from: currentLocation, spacingPixels: spacingPixels)
        postMouseMove(to: target)
        postMouseMove(to: currentLocation)
    }

    private static func postMouseMove(to point: CGPoint) {
        guard let event = CGEvent(
            mouseEventSource: nil,
            mouseType: .mouseMoved,
            mouseCursorPosition: point,
            mouseButton: .left
        ) else { return }
        event.post(tap: .cghidEventTap)
    }
}
