import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import WebKit

struct InstagramPostsWebView: View {
    let url: URL
    let userAgent: String
    let shouldUseSidebar: Bool

    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme

    @State private var refreshKey = 0
    @State private var isLoading = false
    @State private var loadError: String?
    @State private var reloadToken = UUID()

    var body: some View {
        GeometryReader { proxy in
            let background = theme.main.background.color ?? Color.secondary
            let safeTop = proxy.safeAreaInsets.top

            ZStack {
                background.ignoresSafeArea()

                let mode: WebViewRepresentable.Mode = shouldUseSidebar
                ? .manualInsets(
                    topContentInset: safeTop,
                    topIndicatorInset: safeTop
                )

                : .manualInsets(
                    topContentInset: safeTop,
                    topIndicatorInset: safeTop - 90
                )

                WebViewRepresentable(
                    url: url,
                    userAgent: userAgent,
                    backgroundColor: background,
                    mode: mode,
                    refreshKey: refreshKey,
                    isLoading: $isLoading,
                    loadError: $loadError
                )
                .id(reloadToken)
                .ignoresSafeArea(.container, edges: [.top, .bottom])
                .onChange(of: scenePhase) { _, newValue in
                    if newValue == .active { refreshKey += 1 }
                }
                .onChange(of: colorScheme) { _, _ in
                    refreshKey += 1
                }

                if isLoading {
                    ProgressView()
                }
                if loadError != nil {
                    VStack(spacing: 12) {
                        ContentUnavailableView(
                            "Estamos com um problema",
                            systemImage: "square.and.arrow.down.badge.xmark",
                            description: Text(
                                "No momento estamos com um problema técnico. Tente novamente mais tarde."
                            )
                        )

                        Button("Recarregar") {
                            loadError = nil
                            reloadToken = UUID()
                        }
                    }
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding()
                }
            }
        }
    }
}

    // MARK: - UIViewRepresentable

private struct WebViewRepresentable: UIViewRepresentable {
    enum Mode: Equatable {
        case systemManaged
        case manualInsets(topContentInset: CGFloat, topIndicatorInset: CGFloat)
    }

    let url: URL
    let userAgent: String
    let backgroundColor: Color
    let mode: Mode
    let refreshKey: Int

    @Binding var isLoading: Bool
    @Binding var loadError: String?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()

        let javascript = """
        (function() {
          var s = document.createElement('style');
          s.innerHTML = 'html,body{background: transparent !important;}';
          document.head.appendChild(s);
        })();
        """
        let script = WKUserScript(
            source: javascript,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        config.userContentController.addUserScript(script)

        let webView = WKWebView(frame: .zero, configuration: config)

        webView.isOpaque = false
        webView.backgroundColor = .clear

        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = userAgent

            // Configura scroll conforme o modo (iPad vs iPhone)
        configureScrollBehavior(webView, coordinator: context.coordinator)
        applyBackground(to: webView)

        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
            // refreshKey serve para forçar update quando app volta ativo / troca colorScheme
        _ = refreshKey

        configureScrollBehavior(webView, coordinator: context.coordinator)
        applyBackground(to: webView)

        if webView.url != url {
            webView.load(URLRequest(url: url))
        }
    }

    private func configureScrollBehavior(_ webView: WKWebView, coordinator: Coordinator) {
        switch mode {
        case .systemManaged:
            webView.scrollView.contentInsetAdjustmentBehavior = .automatic

            // importantíssimo: não carregar herança do modo manual
            webView.scrollView.contentInset = .zero
            webView.scrollView.verticalScrollIndicatorInsets = .zero
            webView.scrollView.horizontalScrollIndicatorInsets = .zero

            coordinator.didApplyInitialOffset = true
    case let .manualInsets(topContentInset, topIndicatorInset):
            webView.scrollView.contentInsetAdjustmentBehavior = .never
            webView.scrollView.verticalScrollIndicatorInsets.bottom = 12

            var inset = webView.scrollView.contentInset
            inset.top = topContentInset
            webView.scrollView.contentInset = inset

            webView.scrollView.verticalScrollIndicatorInsets.top = topIndicatorInset

            if coordinator.didApplyInitialOffset == false {
                coordinator.didApplyInitialOffset = true
                webView.scrollView.setContentOffset(
                    CGPoint(x: 0, y: -topContentInset),
                    animated: false
                )
            }
        }
    }

    private func applyBackground(to webView: WKWebView) {
        let base = UIColor(backgroundColor)
        let resolved = base.resolvedColor(with: webView.traitCollection)

        webView.scrollView.backgroundColor = resolved
        webView.underPageBackgroundColor = resolved
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        private let parent: WebViewRepresentable
        var didApplyInitialOffset = false

        init(_ parent: WebViewRepresentable) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation?) {
            parent.loadError = nil
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
            parent.isLoading = false
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation?,
            withError error: Error
        ) {
            parent.isLoading = false
            parent.loadError = error.localizedDescription
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation?, withError error: Error) {
            parent.isLoading = false
            parent.loadError = error.localizedDescription
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let targetURL = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }

            guard navigationAction.navigationType == .linkActivated else {
                decisionHandler(.allow)
                return
            }

            if navigationAction.targetFrame?.isMainFrame == false {
                decisionHandler(.allow)
                return
            }

            if isInstagramURL(targetURL) {
                openInstagramOrFallback(targetURL)
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }

        private func isInstagramURL(_ url: URL) -> Bool {
            guard let host = url.host?.lowercased() else { return false }
            return host.contains("instagram.com")
        }

        private func openInstagramOrFallback(_ webURL: URL) {
            if let appURL = makeInstagramAppURL(from: webURL),
               UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL)
                return
            }

            UIApplication.shared.open(webURL)
        }

        private func makeInstagramAppURL(from webURL: URL) -> URL? {
            var components = URLComponents(url: webURL, resolvingAgainstBaseURL: false)
            components?.scheme = "instagram"
            components?.host = nil
            return components?.url
        }
    }
}

