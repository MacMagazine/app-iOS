import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct ShareButton: View {
    let title: String
    let url: URL
    let action: (() -> Void)?

    public init?(
        title: String,
        url: String,
        action: (() -> Void)? = nil
    ) {
        guard let url = URL(string: url) else { return nil }
        self.title = title
        self.url = url
        self.action = action
    }

    public var body: some View {
        Button {
            action?()
            presentShareSheet()
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
        .accessibilityLabel("Compartilhar")
    }

    private func presentShareSheet() {
#if canImport(UIKit)
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let rootVC = scene.keyWindow?.rootViewController else { return }
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        activityVC.popoverPresentationController?.sourceView = topVC.view
        topVC.present(activityVC, animated: true)
#endif
    }
}
