import SwiftUI
import WebKit

@MainActor
class MMWebViewController: NSObject {
    var onStart: (() -> Void)?
    var onFinish: (() -> Void)?
    var onFail: ((Error) -> Void)?
    var onOpenComments: ((String) -> Void)?
}

extension MMWebViewController: WKNavigationDelegate {
    public func webView(
        _ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation?
    ) {
        onStart?()
    }

    public func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation?
    ) {
        onFinish?()
    }

    public func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation?,
        withError error: Error
    ) {
        onFail?(error)
    }

    public func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation?,
        withError error: Error
    ) {
        onFail?(error)
    }

    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        preferences: WKWebpagePreferences,
        decisionHandler: @escaping @MainActor @Sendable (WKNavigationActionPolicy, WKWebpagePreferences) -> Void
    ) {
        var actionPolicy = WKNavigationActionPolicy.allow
        guard let url = navigationAction.request.url else {
            decisionHandler(actionPolicy, preferences)
            return
        }

        switch navigationAction.navigationType {
        case .linkActivated:
            if url.host?.lowercased().contains("instagram.com") ?? false {
                open(url)
            } else if navigationAction.request.url?.absoluteString.contains("comments://") ?? false {
                if let URL = navigationAction.request.url?.absoluteString.replacingOccurrences(of: "comments://", with: "") {
                    let commentsURL = URL.replacingOccurrences(of: "%20", with: " ")
                    onOpenComments?(commentsURL)
                }
            } else if navigationAction.request.url?.absoluteString.contains("#disqus_thread") ?? false {
                print("==> disqus_thread")
            }
            actionPolicy = .cancel

        default: break
        }

        decisionHandler(actionPolicy, preferences)
    }
}

private extension MMWebViewController {
    func open(_ url: URL) {
#if canImport(UIKit)
        UIApplication.shared.open(url)
#endif
    }
}

extension MMWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        print("==> \(message.name)")
    }
}
