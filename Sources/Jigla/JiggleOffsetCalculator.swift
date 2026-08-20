import CoreGraphics

enum JiggleOffsetCalculator {
    static func jiggledPoint(from origin: CGPoint, spacingPixels: Double) -> CGPoint {
        CGPoint(x: origin.x + CGFloat(spacingPixels), y: origin.y)
    }
}
