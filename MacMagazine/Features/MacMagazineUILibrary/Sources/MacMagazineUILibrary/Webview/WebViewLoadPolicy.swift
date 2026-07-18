import Foundation
import SwiftUI

/// Pure decision logic for the WebView lifecycle, extracted for testability.
enum WebViewLoadPolicy {
    /// A load is needed only when the current trigger has not already completed.
    /// When a covered view's `.task(id:)` restarts on pop-back, the trigger is
    /// unchanged and the redundant reload must be skipped to preserve the
    /// reading position.
    static func shouldLoad(trigger: UUID, completedTrigger: UUID?) -> Bool {
        trigger != completedTrigger
    }

    /// Color-scheme changes reported while the scene is not active are the
    /// system rendering app-switcher snapshots in both appearances — not a real
    /// appearance change — and must not trigger a reload.
    static func shouldHandleColorSchemeChange(scenePhase: ScenePhase) -> Bool {
        scenePhase == .active
    }

    /// On return to the active scene, reload only if the appearance genuinely
    /// changed while the scene was away.
    static func needsColorSchemeReconciliation(current: ColorScheme, applied: ColorScheme?) -> Bool {
        guard let applied else { return false }
        return current != applied
    }
}
