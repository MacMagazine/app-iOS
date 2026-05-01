import Foundation
import MacMagazineLibrary
import os
import SwiftUI
@preconcurrency import WebKit

private extension Logger {
    static let webView = Logger(subsystem: "com.macmagazine", category: "WebView")
}

public struct MMWebView: View {
    @Environment(\.removeAds) private var removeAds
    @Environment(\.colorScheme) var colorScheme

    @State private var commentsURL = ""
    @State private var internalLinkURL: URL?
    @State private var page: WebPage?
    @State private var navigationDecider = MMNavigationDecider()
    @State private var reloadID = UUID()

    private let url: String?
    private let cacheKey: String?
    private let dismissAction: (() -> Void)?

    public init(
        url: String?,
        cacheKey: String? = nil,
        dismissAction: (() -> Void)? = nil
    ) {
        self.url = url
        self.cacheKey = cacheKey
        self.dismissAction = dismissAction
    }

    public var body: some View {
        ManagedWebView(
            style: .init(
                ignoredSafeAreaEdges: [.bottom],
                backForwardGesturesDisabled: true
            ),
            pageProvider: { await makePage() },
            loadAction: makeLoadAction(),
            onColorSchemeChange: { _, newScheme in
                await applyCookies(using: newScheme)
            },
            page: $page,
            reloadTrigger: reloadID
        )
        .navigationDestination(item: $internalLinkURL) { url in
            MMWebView(url: url.absoluteString, dismissAction: dismissAction)
                .toolbar {
                    if let dismissAction {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: dismissAction) {
                                Image(systemName: "xmark")
                            }
                            .tint(.primary)
                            .accessibilityLabel("Fechar")
                        }
                    }
                }
        }
        .sheet(isPresented: Binding(get: { !commentsURL.isEmpty },
                                    set: { _ in commentsURL = "" })) {
            DisqusSheet(commentsURL: commentsURL) {
                commentsURL = ""
            }
        }
        .onChange(of: colorScheme) {
            page?.reload()
        }
        .onChange(of: removeAds) { _, newValue in
            guard let page else { return }
            Logger.webView.debug("[Cookie] removeAds changed to \(newValue) — refreshing cookies and reloading")
            Task {
                await applyCookies(using: colorScheme)
                page.reload()
            }
        }
    }
}

// MARK: - Setup

private extension MMWebView {
    func makeLoadAction() -> (@MainActor (WebPage) async throws -> Void)? {
        guard let cacheKey else { return urlLoadAction() }
        if WebPageCache.shared.hasPage(for: cacheKey) {
            // Reload the cached page so it re-reads freshly applied cookies
            return { page in
                Logger.webView.debug("[Cache] Hit for key '\(cacheKey)' — reloading to apply updated cookies")
                page.reload()
                try? await Task.sleep(for: .milliseconds(100))
            }
        }
        Logger.webView.debug("[Cache] Miss for key '\(cacheKey)' — loading URL")
        return urlLoadAction()
    }

    func urlLoadAction() -> @MainActor (WebPage) async throws -> Void {
        return { page in
            guard let url = self.url, let requestURL = URL(string: url) else { return }
            for try await event in page.load(URLRequest(url: requestURL)) {
                if case .finished = event {
                    try? await Task.sleep(for: .milliseconds(50))
                    return
                }
            }
        }
    }

    func makePage() async -> WebPage? {
        guard let url, URL(string: url) != nil else { return nil }

        navigationDecider.onOpenComments = { [self] slug in commentsURL = slug }
        navigationDecider.onOpenInternalLink = { [self] url in internalLinkURL = url }

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

        // Always apply cookies to the shared default store so every page
        // (cached or fresh) reads the current state on next load/reload.
        await applyCookies(using: colorScheme)

        return page
    }

    func makeConfiguration() -> WebPage.Configuration {
        let configuration = WebPage.Configuration()
        let contentController = configuration.userContentController

        contentController.addUserScript(MMWebViewUserScripts.hideSiteHeader)
        contentController.addUserScript(MMWebViewUserScripts.disableGallery)
        contentController.addUserScript(MMWebViewUserScripts.disableNewGallery)
        contentController.addUserScript(MMWebViewUserScripts.removeBackToBlog)

        return configuration
    }

    func makeCookies(using colorScheme: ColorScheme) -> [HTTPCookie] {
        Cookies.makeCookies(
            darkMode: Utils.isDarkMode(for: colorScheme),
            removeAds: removeAds
        )
    }

    func applyCookies(using colorScheme: ColorScheme) async {
        let cookies = makeCookies(using: colorScheme)
        let cookieStore = WKWebsiteDataStore.default().httpCookieStore
        for cookie in cookies {
            await cookieStore.setCookie(cookie)
        }
        Logger.webView.debug("[Cookie] Applied: \(cookies.map { "\($0.name)=\($0.value)" }.joined(separator: ", "))")
    }
}
