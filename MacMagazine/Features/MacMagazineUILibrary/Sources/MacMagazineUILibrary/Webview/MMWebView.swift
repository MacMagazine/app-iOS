import Foundation
import MacMagazineLibrary
import SwiftUI
@preconcurrency import WebKit

public struct MMWebView: View {
    @Environment(\.removeAds) private var removeAds
    @Environment(\.colorScheme) var colorScheme

    @State private var commentsURL = ""
    @State private var internalLinkURL: URL?
    @State private var page: WebPage?
    @State private var navigationDecider = MMNavigationDecider()
    @State private var galleryStateHandler = GalleryStateMessageHandler()
    @State private var isGalleryOpen = false
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
                await updateCookies(for: newScheme)
            },
            page: $page,
            reloadTrigger: reloadID
        )
        .interactivePopGesture(enabled: !isGalleryOpen)
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
        .onChange(of: removeAds) {
            if let cacheKey {
                WebPageCache.shared.removePage(for: cacheKey)
            }
            page = nil
            reloadID = UUID()
        }
    }
}

// MARK: - Setup

private extension MMWebView {
    func makeLoadAction() -> (@MainActor (WebPage) async throws -> Void)? {
        guard let cacheKey else { return urlLoadAction() }
        if WebPageCache.shared.hasPage(for: cacheKey) {
            return nil
        }
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
        galleryStateHandler.onGalleryStateChange = { [self] isOpen in isGalleryOpen = isOpen }

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

        let cookies = makeCookies(using: colorScheme)
        let cookieStore = configuration.websiteDataStore.httpCookieStore
        for cookie in cookies {
            await cookieStore.setCookie(cookie)
        }

        return page
    }

    func makeConfiguration() -> WebPage.Configuration {
        let configuration = WebPage.Configuration()
        let contentController = configuration.userContentController

        contentController.addUserScript(MMWebViewUserScripts.hideSiteHeader)
        contentController.addUserScript(MMWebViewUserScripts.disableGallery)
        contentController.addUserScript(MMWebViewUserScripts.disableNewGallery)
        contentController.addUserScript(MMWebViewUserScripts.removeBackToBlog)
        contentController.addUserScript(MMWebViewUserScripts.galleryStateObserver)
        contentController.add(galleryStateHandler, name: GalleryStateMessageHandler.handlerName)

        return configuration
    }

    func makeCookies(using colorScheme: ColorScheme) -> [HTTPCookie] {
        Cookies.makeCookies(
            darkMode: Utils.isDarkMode(for: colorScheme),
            removeAds: removeAds
        )
    }

    func updateCookies(for colorScheme: ColorScheme) async {
        let cookies = makeCookies(using: colorScheme)
        let cookieStore = WKWebsiteDataStore.default().httpCookieStore
        for cookie in cookies {
            await cookieStore.setCookie(cookie)
        }
    }

}
