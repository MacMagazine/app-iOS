import Foundation
@preconcurrency import WebKit

final class ImageTappedHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        print("==> \(message.name)")
        guard let body = message.body as? String,
              let url = URL(string: body) else {
            return
        }
        print("==> \(url)")
//        if url.isMMAddress() &&
//            !url.isAppStoreBadge() {
//            openInSafari(url)
//        }
    }
}

final class GotCommentURLHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        print("==> \(message.name)")
        guard let body = message.body as? String else {
            return
        }
        print("==> \(body)")
        // commentsURL = body
    }
}
