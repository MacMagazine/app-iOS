import Foundation
import MacMagazineLibrary
import SwiftUI
@preconcurrency import WebKit

public struct MMWebView: View {
    @Environment(\.removeAds) private var removeAds
    @Environment(\.colorScheme) var colorScheme

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
        ManagedWebView(
            style: .init(
                ignoredSafeAreaEdges: [.top, .bottom],
                backForwardGesturesDisabled: true,
                reloadsOnColorSchemeChange: true
            ),
            pageProvider: { await makePage() },
            loadAction: makeLoadAction(),
            page: $page
        )
        .onAppear {
            navigationDecider.onOpenComments = { url in
                commentsURL = url
            }
        }
        .sheet(isPresented: Binding(get: { !commentsURL.isEmpty },
                                    set: { _ in commentsURL = "" })) {
            DisqusSheet(commentsURL: commentsURL) {
                commentsURL = ""
            }
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

        // Return cached page if available
        if let cacheKey, WebPageCache.shared.hasPage(for: cacheKey) {
            return WebPageCache.shared.page(
                for: cacheKey,
                configurationProvider: { makeConfiguration() },
                navigationDecider: navigationDecider
            )
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
// MARK: - Disqus Data Store

/// Shared persistent data store for all Disqus webviews so cookies are
/// preserved between the comments page and the login page.
@MainActor
private enum DisqusDataStore {
    static let shared: WKWebsiteDataStore = {
        WKWebsiteDataStore(forIdentifier: UUID(uuidString: "D15QU5C0-0K1E-5700-BE00-MACMAGAZINE0")!)
    }()
}

// MARK: - Disqus Sheet

private struct DisqusSheet: View {
    @Environment(\.colorScheme) private var colorScheme

    @State private var page: WebPage?
    @State private var loginURL: URL?
    @State private var reloadToken = UUID()
    @State private var newWindowHandler = DisqusNewWindowHandler()

    let commentsURL: String
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ManagedWebView(
                style: .init(
                    backForwardGesturesDisabled: true,
                    reloadsOnColorSchemeChange: true
                ),
                pageProvider: { await makePageAndConfigure() },
                loadAction: { page in
                    let html = DisqusHTMLBuilder.makeHTML(
                        commentsURL: commentsURL,
                        colorScheme: colorScheme
                    )
                    for try await event in page.load(html: html) {
                        if case .finished = event { return }
                    }
                },
                page: $page,
                reloadTrigger: reloadToken
            )
            .navigationTitle("Comentários")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { onDismiss() },
                           label: { Image(systemName: "xmark.circle") })
                    .buttonStyle(.plain)
                    .tint(.primary)
                    .glassEffect(.regular.interactive(), in: .circle)
                }
            }
        }
        .presentationDragIndicator(.visible)
        .sheet(isPresented: Binding(
            get: { loginURL != nil },
            set: { if !$0 { loginURL = nil } }
        )) {
            if let loginURL {
                NavigationStack {
                    DisqusLoginWebView(
                        url: loginURL,
                        dataStore: DisqusDataStore.shared,
                        onLoginSuccess: {
                            Task {
                                await Cookies.saveDisqusCookies(
                                    from: DisqusDataStore.shared.httpCookieStore
                                )
                            }
                            self.loginURL = nil
                            reloadToken = UUID()
                        }
                    )
                    .navigationTitle("Login")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: { self.loginURL = nil },
                                   label: { Image(systemName: "xmark.circle") })
                            .buttonStyle(.plain)
                            .tint(.primary)
                            .glassEffect(.regular.interactive(), in: .circle)
                        }
                    }
                }
            }
        }
    }

    private func makePageAndConfigure() async -> WebPage {
        newWindowHandler.onNewWindow = { url in
            loginURL = url
        }
        let configuration = WebPage.Configuration()
        configuration.websiteDataStore = DisqusDataStore.shared

        // Restore previously saved Disqus login cookies
        await Cookies.restoreDisqusCookies(
            to: DisqusDataStore.shared.httpCookieStore
        )

        let contentController = configuration.userContentController
        contentController.addUserScript(MMWebViewUserScripts.interceptNewWindows)
        contentController.add(newWindowHandler, name: "newWindowHandler")
        return WebPage(configuration: configuration)
    }
}

// MARK: - Disqus Login WebView
private struct DisqusLoginWebView: View {
    @Environment(\.scenePhase) private var scenePhase

    @State private var loginPage: WebPage?
    @State private var isActive = true

    let url: URL
    let dataStore: WKWebsiteDataStore
    let onLoginSuccess: @MainActor () -> Void

    var body: some View {
        Group {
            if isActive, let loginPage {
                WebView(loginPage)
            }
        }
        .task {
            let configuration = WebPage.Configuration()
            configuration.websiteDataStore = dataStore
            let page = WebPage(configuration: configuration)
            loginPage = page
            page.load(URLRequest(url: url))
        }
        .onChange(of: scenePhase) { _, newPhase in
            isActive = newPhase == .active
        }
        .onChange(of: loginPage?.url) { _, newURL in
            if let path = newURL?.path, path.contains("/next/login-success") {
                onLoginSuccess()
            }
        }
    }
}

