import Foundation
@preconcurrency import WebKit

final class DisqusNewWindowHandler: NSObject, WKScriptMessageHandler {
    var onNewWindow: (@MainActor (URL) -> Void)?

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard let body = message.body as? String,
              let url = URL(string: body) else {
            return
        }
        Task { @MainActor in
            onNewWindow?(url)
        }
    }
}
