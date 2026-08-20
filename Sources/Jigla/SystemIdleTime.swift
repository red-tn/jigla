import Foundation
import IOKit

enum SystemIdleTime {
    /// Seconds since the last input event of ANY kind (keyboard, mouse,
    /// trackpad), read from IOKit's HIDIdleTime — the same signal the
    /// system's own sleep/screensaver logic uses. Returns nil if the
    /// registry read fails.
    static func seconds() -> Double? {
        var iterator: io_iterator_t = 0
        guard IOServiceGetMatchingServices(kIOMainPortDefault, IOServiceMatching("IOHIDSystem"), &iterator) == KERN_SUCCESS else {
            return nil
        }
        defer { IOObjectRelease(iterator) }

        let entry = IOIteratorNext(iterator)
        guard entry != 0 else { return nil }
        defer { IOObjectRelease(entry) }

        var unmanagedProps: Unmanaged<CFMutableDictionary>?
        guard IORegistryEntryCreateCFProperties(entry, &unmanagedProps, kCFAllocatorDefault, 0) == KERN_SUCCESS,
              let props = unmanagedProps?.takeRetainedValue() as? [String: Any],
              let idleNanoseconds = props["HIDIdleTime"] as? UInt64 else {
            return nil
        }
        return Double(idleNanoseconds) / 1_000_000_000
    }
}
