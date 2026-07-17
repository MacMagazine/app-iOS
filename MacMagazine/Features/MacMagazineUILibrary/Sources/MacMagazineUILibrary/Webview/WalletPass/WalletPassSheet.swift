import PassKit
import SwiftUI
import UIKit

/// Presents the system "Add to Wallet" flow for a `.pkpass` link tapped inside a `MMWebView`.
struct WalletPassSheet: View {
    let url: URL
    let onDismiss: () -> Void

    @State private var addPassesController: PKAddPassesViewController?
    @State private var status = WebViewStatus.idle

    var body: some View {
        ZStack {
            if let addPassesController {
                AddPassesView(controller: addPassesController, onDismiss: onDismiss)
            }
            WebViewStatusOverlay(status: status)
        }
        .task {
            await loadPass()
        }
    }
}

private extension WalletPassSheet {
    func loadPass() async {
        status = .loading
        do {
            let pass = try await WalletPassService().fetchPass(from: url)
            guard let controller = PKAddPassesViewController(pass: pass) else {
                status = .error("Não foi possível adicionar este tíquete à Carteira.")
                return
            }
            addPassesController = controller
            status = .done
        } catch {
            status = .error("Não foi possível adicionar este tíquete à Carteira.")
        }
    }
}

// MARK: - UIKit bridge

private struct AddPassesView: UIViewControllerRepresentable {
    let controller: PKAddPassesViewController
    let onDismiss: () -> Void

    func makeUIViewController(context: Context) -> PKAddPassesViewController {
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: PKAddPassesViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onDismiss: onDismiss)
    }

    final class Coordinator: NSObject, PKAddPassesViewControllerDelegate {
        private let onDismiss: () -> Void

        init(onDismiss: @escaping () -> Void) {
            self.onDismiss = onDismiss
        }

        func addPassesViewControllerDidFinish(_ controller: PKAddPassesViewController) {
            onDismiss()
        }
    }
}
