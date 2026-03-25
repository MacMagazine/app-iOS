import Foundation
@preconcurrency import WebKit

final class ImageTappedHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        guard let body = message.body as? String,
              let url = URL(string: body) else {
            return
        }
    }
}
