import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import WebKit

struct InstagramPostsWebView: View {
    let url: URL
    let userAgent: String
    let shouldUseSidebar: Bool

    @Environment(\.theme) private var theme: ThemeColor

    @State private var isPresenting = true
    @State private var isLoading = true
    @State private var loadError: String?

    private let navigationDelegate = InstagramNavigationDelegate()

    private var userScripts: [WKUserScript] {
        [
            WKUserScript(
                source: """
                (function() {
                  var style = document.createElement('style');
                  style.innerHTML = `
                    html, body {
                      padding-top: 50px !important;
                      background-color: transparent !important;
                    }
                
                    @media (prefers-color-scheme: dark) {
                      html, body { background-color: #1C1B1D !important; }
                    }
                
                    @media (prefers-color-scheme: light) {
                      html, body { background-color: #F2F2F7 !important; }
                    }
                  `;
                  document.head.appendChild(style);
                })();
                """,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: true
            )
        ]
    }

    var body: some View {
        ZStack {
            (theme.main.background.color ?? Color.secondary)
                .ignoresSafeArea()

            Webview(
                title: nil,
                url: url.absoluteString,
                isPresenting: $isPresenting,
                standAlone: true,
                navigationDelegate: navigationDelegate,
                userScripts: userScripts,
                userAgent: userAgent
            )
            .ignoresSafeArea(.container, edges: [.top, .bottom])
            .opacity(isLoading ? 0 : 1)
            .animation(.easeInOut(duration: 0.25), value: isLoading)

            if isLoading {
                ProgressView()
                    .transition(.opacity)
            }

            if loadError != nil {
                ContentUnavailableView(
                    "Estamos com um problema",
                    systemImage: "square.and.arrow.down.badge.xmark",
                    description: Text("No momento estamos com um problema técnico. Tente novamente mais tarde.")
                )
            }
        }
        .onAppear {
            navigationDelegate.onStart = { isLoading = true; loadError = nil }
            navigationDelegate.onFinish = {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    isLoading = false
                }
            }
            navigationDelegate.onFail = { error in
                isLoading = false
                loadError = error.localizedDescription
            }
        }
    }
}

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
