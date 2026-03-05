import Foundation
import SwiftUI
@preconcurrency import WebKit

struct DisqusWebView: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var viewStatus = WebViewStatus.idle
    @State private var newWindowHandler = DisqusNewWindowHandler()
    @State private var page: WebPage?
    @State private var loginURL: URL?

    private let commentsURL: String

    init(commentsURL: String) {
        self.commentsURL = commentsURL
    }

    var body: some View {
        ZStack {
            webview.transition(.opacity)
            WebViewStatusOverlay(status: viewStatus)
        }
        .task {
            configureNewWindowHandler()
            page = makeConfiguredPage()
            await loadContent()
        }
        .sheet(isPresented: Binding(
            get: { loginURL != nil },
            set: { if !$0 { loginURL = nil } }
        )) {
            if let loginURL {
                NavigationStack {
                    DisqusLoginWebView(url: loginURL, onLoginSuccess: {
                        self.loginURL = nil
                        reloadPage()
                    })
                        .navigationTitle("Login")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button(action: { self.loginURL = nil },
                                       label: { Text("Fechar") })
                                .buttonStyle(.plain)
                                .tint(.primary)
                                .glassEffect(.regular.interactive(), in: .capsule)
                            }
                        }
                }
            }
        }
    }
}

// MARK: - Login WebView

private struct DisqusLoginWebView: View {
    @State private var loginPage = WebPage()

    let url: URL
    let onLoginSuccess: @MainActor () -> Void

    var body: some View {
        WebView(loginPage)
            .task {
                loginPage.load(URLRequest(url: url))
            }
            .onChange(of: loginPage.url) { _, newURL in
                if let path = newURL?.path, path.contains("/next/login-success") {
                    onLoginSuccess()
                }
            }
    }
}

// MARK: - Private

private extension DisqusWebView {
    @ViewBuilder
    var webview: some View {
        if let page {
            WebView(page)
                .webViewBackForwardNavigationGestures(.disabled)
                .id(colorScheme)
                .opacity(viewStatus == .done ? 1 : 0)
        }
    }

    func configureNewWindowHandler() {
        newWindowHandler.onNewWindow = { url in
            loginURL = url
        }
    }

    func makeConfiguredPage() -> WebPage {
        let configuration = WebPage.Configuration()
        let contentController = configuration.userContentController
        contentController.addUserScript(MMWebViewUserScripts.interceptNewWindows)
        contentController.add(newWindowHandler, name: "newWindowHandler")
        return WebPage(configuration: configuration)
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
                switch event {
                case .startedProvisionalNavigation, .receivedServerRedirect, .committed:
                    break
                case .finished:
                    viewStatus = .done
                @unknown default:
                    break
                }
            }
        } catch {
            viewStatus = .error(error.localizedDescription)
        }
    }
}

