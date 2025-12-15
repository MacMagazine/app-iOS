import SwiftUI
import WebKit

final class InstagramNavigationDelegate: NSObject, WKNavigationDelegate {
    var onStart: (() -> Void)?
    var onFinish: (() -> Void)?
    var onFail: ((Error) -> Void)?

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation?) {
        onStart?()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
        onFinish?()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation?, withError error: Error) {
        onFail?(error)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation?, withError error: Error) {
        onFail?(error)
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }

        guard navigationAction.navigationType == .linkActivated else {
            decisionHandler(.allow)
            return
        }

        if url.host?.lowercased().contains("instagram.com") == true {
            if let appURL = makeInstagramAppURL(from: url),
               UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL)
            } else {
                UIApplication.shared.open(url)
            }
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }

    private func makeInstagramAppURL(from webURL: URL) -> URL? {
        var components = URLComponents(url: webURL, resolvingAgainstBaseURL: false)
        components?.scheme = "instagram"
        components?.host = nil
        return components?.url
    }
}
