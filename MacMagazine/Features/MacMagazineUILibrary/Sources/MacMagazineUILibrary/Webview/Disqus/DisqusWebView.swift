import SwiftUI
@preconcurrency import WebKit

// MARK: - Disqus Sheet

struct DisqusSheet: View {
    @Environment(\.colorScheme) private var colorScheme

    @State private var viewStatus = WebViewStatus.idle
    @State private var newWindowHandler = DisqusNewWindowHandler()
    @State private var page: WebPage?
    @State private var loginURL: URL?

    let commentsURL: String
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                if let page {
                    WebView(page)
                        .webViewBackForwardNavigationGestures(.disabled)
                        .id(colorScheme)
                        .opacity(viewStatus == .done ? 1 : 0)
                }
                WebViewStatusOverlay(status: viewStatus)
            }
            .navigationTitle("Comentários")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { onDismiss() },
                           label: { Image(systemName: "xmark") })
                    .tint(.primary)
                }
            }
        }
        .presentationDragIndicator(.visible)
        .task {
            configureNewWindowHandler()
            await setupPage()
            await loadContent()
        }
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
                            reloadPage()
                        }
                    )
                    .navigationTitle("Login")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: { self.loginURL = nil },
                                   label: { Image(systemName: "xmark") })
                            .tint(.primary)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Private Helpers

private extension DisqusSheet {
    func configureNewWindowHandler() {
        newWindowHandler.onNewWindow = { url in
            loginURL = url
        }
    }

    func setupPage() async {
        var configuration = WebPage.Configuration()
        configuration.websiteDataStore = DisqusDataStore.shared

        await Cookies.restoreDisqusCookies(
            to: DisqusDataStore.shared.httpCookieStore
        )

        let contentController = configuration.userContentController
        contentController.addUserScript(MMWebViewUserScripts.interceptNewWindows)
        contentController.add(newWindowHandler, name: "newWindowHandler")

        page = WebPage(configuration: configuration)
    }

    func reloadPage() {
        Task {
            await loadContent()
        }
    }

    func loadContent() async {
        guard let page else { return }
        let html = DisqusHTMLBuilder.makeHTML(
            commentsURL: commentsURL,
            colorScheme: colorScheme
        )
        viewStatus = .loading
        do {
            for try await event in page.load(html: html) {
                if case .finished = event {
                    viewStatus = .done
                    return
                }
            }
        } catch {
            viewStatus = .error(error.localizedDescription)
        }
    }
}

// MARK: - Disqus Login WebView

private struct DisqusLoginWebView: View {
    @State private var loginPage = WebPage()

    let url: URL
    let dataStore: WKWebsiteDataStore
    let onLoginSuccess: @MainActor () -> Void

    var body: some View {
        WebView(loginPage)
            .task {
                var configuration = WebPage.Configuration()
                configuration.websiteDataStore = dataStore
                let page = WebPage(configuration: configuration)
                loginPage = page
                page.load(URLRequest(url: url))
            }
            .onChange(of: loginPage.url) { _, newURL in
                if let path = newURL?.path, path.contains("/next/login-success") {
                    onLoginSuccess()
                }
            }
    }
}
