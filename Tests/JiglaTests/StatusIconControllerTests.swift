import XCTest
@testable import Jigla

final class StatusIconControllerTests: XCTestCase {
    func test_offMode_returnsOffSymbol() {
        XCTAssertEqual(StatusIconController.symbolName(for: .off, isActivelyJiggling: false), "circle")
    }

    func test_continuousMode_activelyJiggling_returnsFilledSymbol() {
        XCTAssertEqual(StatusIconController.symbolName(for: .continuous, isActivelyJiggling: true), "circle.fill")
    }

    func test_continuousMode_notCurrentlyJiggling_stillReturnsFilledSymbol() {
        // "Continuous" mode is armed even between jiggles, so it always shows as active.
        XCTAssertEqual(StatusIconController.symbolName(for: .continuous, isActivelyJiggling: false), "circle.fill")
    }

    func test_zenMode_returnsZenSymbol() {
        XCTAssertEqual(StatusIconController.symbolName(for: .zen, isActivelyJiggling: true), "moon.zzz.fill")
    }
}
