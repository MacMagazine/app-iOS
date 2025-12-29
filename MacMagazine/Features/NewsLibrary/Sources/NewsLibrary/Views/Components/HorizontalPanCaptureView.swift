import SwiftUI
import UIKit

// MARK: - Horizontal Pan Capture View

/// UIViewRepresentable that captures horizontal pan gestures
/// Used to handle carousel swipe without conflicting with vertical ScrollView
struct HorizontalPanCaptureView: UIViewRepresentable {
    let onTap: () -> Void
    let onChanged: (CGFloat) -> Void
    let onEnded: (CGFloat, CGFloat) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onTap: onTap, onChanged: onChanged, onEnded: onEnded)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear

        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        pan.delegate = context.coordinator
        pan.cancelsTouchesInView = false

        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        tap.delegate = context.coordinator
        tap.cancelsTouchesInView = false

        tap.require(toFail: pan)

        view.addGestureRecognizer(pan)
        view.addGestureRecognizer(tap)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        let onTap: () -> Void
        let onChanged: (CGFloat) -> Void
        let onEnded: (CGFloat, CGFloat) -> Void

        init(
            onTap: @escaping () -> Void,
            onChanged: @escaping (CGFloat) -> Void,
            onEnded: @escaping (CGFloat, CGFloat) -> Void
        ) {
            self.onTap = onTap
            self.onChanged = onChanged
            self.onEnded = onEnded
        }

        @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard recognizer.state == .ended else { return }
            onTap()
        }

        @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
            let translation = recognizer.translation(in: recognizer.view)
            let velocity = recognizer.velocity(in: recognizer.view)

            switch recognizer.state {
            case .began, .changed:
                onChanged(translation.x)

            case .ended, .cancelled, .failed:
                onEnded(translation.x, velocity.x)

            default:
                break
            }
        }

        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
            true
        }
    }
}
