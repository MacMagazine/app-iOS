import Foundation
import MacMagazineLibrary
import SwiftUI
@preconcurrency import WebKit

public struct MMWebView: View {
    @Environment(\.removeAds) private var removeAds
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.theme) private var theme: ThemeColor

    @State private var viewStatus = WebViewStatus.idle
    @State private var commentsURL = ""
    @State private var page: WebPage?
    @State private var navigationDecider = MMNavigationDecider()
    @State private var imageTappedHandler = ImageTappedHandler()

    private let url: String?
    private let cacheKey: String?

    public init(
        url: String?,
        cacheKey: String? = nil
    ) {
        self.url = url
        self.cacheKey = cacheKey
    }

    public var body: some View {
        ZStack {
            webview.transition(.opacity)
            WebViewStatusOverlay(status: viewStatus)
        }
        .task {
            navigationDecider.onOpenComments = { url in
                commentsURL = url
            }
            await setupAndLoad()
        }
        .sheet(isPresented: Binding(get: { !commentsURL.isEmpty },
                                    set: { _ in commentsURL = "" })) {
            DisqusSheet(commentsURL: commentsURL) {
                commentsURL = ""
            }
        }
    }
}

// MARK: - WebView

private extension MMWebView {
    @ViewBuilder
    var webview: some View {
        if let page {
            WebView(page)
                .webViewBackForwardNavigationGestures(.disabled)
                .id(colorScheme)
                .ignoresSafeArea(.container, edges: [.top, .bottom])
                .opacity(viewStatus == .done ? 1 : 0)
        }
    }
}

// MARK: - Setup

private extension MMWebView {
    func setupAndLoad() async {
        guard let url, let requestURL = URL(string: url) else { return }

        // If we already have a cached page loaded, just show it
        if let cacheKey, WebPageCache.shared.hasPage(for: cacheKey) {
            let page = WebPageCache.shared.page(
                for: cacheKey,
                configurationProvider: { makeConfiguration() },
                navigationDecider: navigationDecider
            )
            self.page = page
            viewStatus = .done
            return
        }

        let configuration = makeConfiguration()
        let page: WebPage

        if let cacheKey {
            page = WebPageCache.shared.page(
                for: cacheKey,
                configurationProvider: { configuration },
                navigationDecider: navigationDecider
            )
        } else {
            page = WebPage(
                configuration: configuration,
                navigationDecider: navigationDecider
            )
        }

        page.customUserAgent = Utils.userAgent
        self.page = page

        let cookies = makeCookies(using: colorScheme)
        let cookieStore = configuration.websiteDataStore.httpCookieStore
        for cookie in cookies {
            await cookieStore.setCookie(cookie)
        }

        viewStatus = .loading

        do {
            for try await event in page.load(URLRequest(url: requestURL)) {
                switch event {
                case .startedProvisionalNavigation, .receivedServerRedirect, .committed:
                    break
                case .finished:
                    try? await Task.sleep(for: .milliseconds(50))
                    viewStatus = .done
                @unknown default:
                    break
                }
            }
        } catch is CancellationError {
            // Task cancelled (view disappeared, app backgrounded) — not an error
        } catch {
            viewStatus = .error(error.localizedDescription)
        }
    }

    func makeConfiguration() -> WebPage.Configuration {
        let configuration = WebPage.Configuration()
        let contentController = configuration.userContentController

        contentController.addUserScript(MMWebViewUserScripts.topPadding)
        contentController.addUserScript(MMWebViewUserScripts.tapToZoom)
        contentController.addUserScript(MMWebViewUserScripts.disableGallery)
        contentController.addUserScript(MMWebViewUserScripts.disableNewGallery)
        contentController.addUserScript(MMWebViewUserScripts.removeBackToBlog)

        contentController.add(imageTappedHandler, name: "imageTappedHandler")

        return configuration
    }

    func makeCookies(using colorScheme: ColorScheme) -> [HTTPCookie] {
        Cookies.makeCookies(
            darkMode: Utils.isDarkMode(for: colorScheme),
            removeAds: removeAds
        )
    }
}
// MARK: - Disqus Sheet

private struct DisqusSheet: View {
    let commentsURL: String
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            DisqusWebView(commentsURL: commentsURL)
                .navigationTitle("Comentários")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: { onDismiss() },
                               label: { Text("Fechar") })
                        .buttonStyle(.plain)
                        .tint(.primary)
                        .glassEffect(.regular.interactive(), in: .capsule)
                    }
                }
        }
        .presentationDragIndicator(.visible)
    }
}

