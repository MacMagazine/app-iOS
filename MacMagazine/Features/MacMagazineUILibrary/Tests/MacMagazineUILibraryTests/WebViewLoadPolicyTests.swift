import Foundation
@testable import MacMagazineUILibrary
import SwiftUI
import Testing

@Suite("WebViewLoadPolicy Tests")
struct WebViewLoadPolicyTests {

    // MARK: - shouldLoad

    @Test("Should load on first appearance when no load has completed")
    func firstLoad() {
        // Given
        let trigger = UUID()

        // Then
        #expect(WebViewLoadPolicy.shouldLoad(trigger: trigger, completedTrigger: nil))
    }

    @Test("Should skip reload when reappearing with the same completed trigger")
    func skipAfterPopBack() {
        // Given
        let trigger = UUID()

        // Then
        #expect(!WebViewLoadPolicy.shouldLoad(trigger: trigger, completedTrigger: trigger))
    }

    @Test("Should load again when the trigger rotates")
    func reloadOnRotatedTrigger() {
        #expect(WebViewLoadPolicy.shouldLoad(trigger: UUID(), completedTrigger: UUID()))
    }

    // MARK: - shouldHandleColorSchemeChange

    @Test("Should handle color-scheme change only while the scene is active",
          arguments: zip([ScenePhase.active, .inactive, .background], [true, false, false]))
    func schemeChangeGating(phase: ScenePhase, expected: Bool) {
        #expect(WebViewLoadPolicy.shouldHandleColorSchemeChange(scenePhase: phase) == expected)
    }

    // MARK: - needsColorSchemeReconciliation

    @Test("Should not reconcile before any scheme was applied")
    func noReconciliationWhenNeverApplied() {
        #expect(!WebViewLoadPolicy.needsColorSchemeReconciliation(current: .dark, applied: nil))
    }

    @Test("Should not reconcile when the scheme is unchanged",
          arguments: [ColorScheme.light, .dark])
    func noReconciliationWhenUnchanged(scheme: ColorScheme) {
        #expect(!WebViewLoadPolicy.needsColorSchemeReconciliation(current: scheme, applied: scheme))
    }

    @Test("Should reconcile when the scheme changed while away")
    func reconciliationWhenChanged() {
        #expect(WebViewLoadPolicy.needsColorSchemeReconciliation(current: .dark, applied: .light))
    }
}
