import Foundation

enum StatusIconController {
    static func symbolName(for mode: JiggleMode, isActivelyJiggling: Bool) -> String {
        switch mode {
        case .off:
            return "circle"
        case .continuous:
            return "circle.fill"
        case .zen:
            return "moon.zzz.fill"
        }
    }
}
