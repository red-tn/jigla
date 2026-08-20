import XCTest
@testable import Jigla

final class IdleThresholdTests: XCTestCase {
    func test_wellBelowThreshold_doesNotJiggle() {
        XCTAssertFalse(IdleThreshold.shouldZenJiggle(idleSeconds: 60, sleepThresholdSeconds: 600))
    }

    func test_justBeforeThreshold_jiggles() {
        // 600 - 15 = 585, so 590 should trigger
        XCTAssertTrue(IdleThreshold.shouldZenJiggle(idleSeconds: 590, sleepThresholdSeconds: 600))
    }

    func test_exactlyAtSafetyMargin_jiggles() {
        XCTAssertTrue(IdleThreshold.shouldZenJiggle(idleSeconds: 585, sleepThresholdSeconds: 600))
    }

    func test_justBeforeSafetyMargin_doesNotJiggle() {
        XCTAssertFalse(IdleThreshold.shouldZenJiggle(idleSeconds: 584, sleepThresholdSeconds: 600))
    }

    func test_pastThreshold_stillJiggles() {
        XCTAssertTrue(IdleThreshold.shouldZenJiggle(idleSeconds: 700, sleepThresholdSeconds: 600))
    }

    func test_customSafetyMargin_isRespected() {
        XCTAssertTrue(IdleThreshold.shouldZenJiggle(idleSeconds: 595, sleepThresholdSeconds: 600, safetyMarginSeconds: 5))
        XCTAssertFalse(IdleThreshold.shouldZenJiggle(idleSeconds: 594, sleepThresholdSeconds: 600, safetyMarginSeconds: 5))
    }
}
