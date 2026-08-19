import XCTest
@testable import Jiggler
import CoreGraphics

final class JiggleOffsetCalculatorTests: XCTestCase {
    func test_jiggledPoint_movesRightByExactSpacing() {
        let origin = CGPoint(x: 100, y: 200)
        let result = JiggleOffsetCalculator.jiggledPoint(from: origin, spacingPixels: 8)
        XCTAssertEqual(result.x, 108)
        XCTAssertEqual(result.y, 200)
    }

    func test_jiggledPoint_withZeroSpacing_returnsSamePoint() {
        let origin = CGPoint(x: 50, y: 50)
        let result = JiggleOffsetCalculator.jiggledPoint(from: origin, spacingPixels: 0)
        XCTAssertEqual(result.x, 50)
        XCTAssertEqual(result.y, 50)
    }
}
