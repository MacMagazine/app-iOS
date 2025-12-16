import SwiftUI
import WebKit

@MainActor
public class MMWebViewController: NSObject {
    var onStart: (() -> Void)?
    var onFinish: (() -> Void)?
    var onFail: ((Error) -> Void)?
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
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel, preferences)
            return
        }

        guard navigationAction.navigationType == .linkActivated else {
            decisionHandler(.allow, preferences)
            return
        }

        if url.host?.lowercased().contains("instagram.com") ?? false {
#if canImport(UIKit)
            UIApplication.shared.open(url)
#endif
            decisionHandler(.cancel, preferences)
            return
        }

        decisionHandler(.allow, preferences)
    }
}
