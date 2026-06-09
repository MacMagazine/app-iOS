import SwiftUI
import UIKit

public extension View {
    /// Restores the interactive pop gesture (swipe from the leading edge to go back)
    /// even when the system back button is hidden, and disables it on demand —
    /// e.g. while an in-page image gallery is open and owns horizontal swipes.
    func interactivePopGesture(enabled: Bool) -> some View {
        background(InteractivePopGestureBridge(enabled: enabled))
    }
}

private struct InteractivePopGestureBridge: UIViewControllerRepresentable {
    let enabled: Bool

    func makeUIViewController(context: Context) -> BridgeViewController {
        BridgeViewController()
    }

    func updateUIViewController(_ controller: BridgeViewController, context: Context) {
        controller.gestureEnabled = enabled
    }
}

private final class BridgeViewController: UIViewController, UIGestureRecognizerDelegate {
    var gestureEnabled = true

    private weak var popGesture: UIGestureRecognizer?
    private weak var originalDelegate: UIGestureRecognizerDelegate?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard popGesture == nil,
              let gesture = navigationController?.interactivePopGestureRecognizer else { return }
        popGesture = gesture
        originalDelegate = gesture.delegate
        gesture.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let popGesture, popGesture.delegate === self {
            popGesture.delegate = originalDelegate
        }
        popGesture = nil
        originalDelegate = nil
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController else { return false }
        return gestureEnabled
            && navigationController.viewControllers.count > 1
            && navigationController.transitionCoordinator == nil
    }
}
