import SwiftUI
@preconcurrency import WebKit

public struct SimpleWebView: View {
    @State private var page: WebPage?
    @State private var viewStatus = WebViewStatus.idle

    private let url: String
    private let userScripts: [WKUserScript]
    private let onNavigationCommitted: (@MainActor (URL) -> Void)?

    public init(
        url: String,
        userScripts: [WKUserScript] = [],
        onNavigationCommitted: (@MainActor (URL) -> Void)? = nil
    ) {
        self.url = url
        self.userScripts = userScripts
        self.onNavigationCommitted = onNavigationCommitted
    }

    public var body: some View {
        ZStack {
            if let page {
                WebView(page)
                    .opacity(viewStatus == .done ? 1 : 0)
            }
            WebViewStatusOverlay(status: viewStatus)
        }
        .task {
            await loadContent()
        }
    }
}

private extension SimpleWebView {
    func loadContent() async {
        guard let requestURL = URL(string: url) else {
            viewStatus = .error("URL inválida")
            return
        }

        let configuration = WebPage.Configuration()
        for script in userScripts {
            configuration.userContentController.addUserScript(script)
        }

        let page = WebPage(configuration: configuration)
        self.page = page

        viewStatus = .loading

        if onNavigationCommitted != nil {
            Task { @MainActor in
                await observeNavigations(page: page)
            }
        }

        do {
            for try await event in page.load(URLRequest(url: requestURL)) {
                switch event {
                case .startedProvisionalNavigation, .receivedServerRedirect, .committed:
                    break
                case .finished:
                    viewStatus = .done
                @unknown default:
                    break
                }
            }
        } catch is CancellationError {
            // Task cancelled — not an error
        } catch {
            viewStatus = .error(error.localizedDescription)
        }
    }

    func observeNavigations(page: WebPage) async {
        do {
            for try await event in page.navigations {
                switch event {
                case .committed:
                    if let currentURL = page.url {
                        onNavigationCommitted?(currentURL)
                    }
                default:
                    break
                }
            }
        } catch {
            // Navigation observation ended
        }
    }
}
