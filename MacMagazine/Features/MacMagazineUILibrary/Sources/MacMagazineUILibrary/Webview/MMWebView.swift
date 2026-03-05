import Foundation
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public struct MMWebView: View {
    @Environment(\.removeAds) private var removeAds
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.theme) private var theme: ThemeColor

    @State private var viewStatus = WebViewStatus.idle
    @State private var commentsURL = ""

    private let controller = MMWebViewController()
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
            webview(url: url).transition(.opacity)
            WebViewStatusOverlay(status: viewStatus)
        }
        .task {
            controller.onStart = {
                viewStatus = viewStatus == .idle ? .loading : viewStatus
            }
            controller.onFinish = {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    viewStatus = .done
                }
            }
            controller.onFail = { error in
                viewStatus = .error(error.localizedDescription)
            }
            controller.onOpenComments = { url in
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

private extension MMWebView {
    @ViewBuilder
    func webview(url: String?) -> some View {
        if let url {
            Webview(
                url: url,
                isPresenting: .constant(true),
                standAlone: true,
                navigationDelegate: controller,
                userScripts: [
                    MMWebViewUserScripts.topPadding,
                    MMWebViewUserScripts.tapToZoom,
                    MMWebViewUserScripts.disableGallery,
                    MMWebViewUserScripts.disableNewGallery,
                    MMWebViewUserScripts.removeBackToBlog
                ],
                cookies: makeCookies(using: colorScheme),
                scriptMessageHandlers: [
                    (controller, "imageTappedHandler")
                ],
                userAgent: Utils.userAgent,
                cacheKey: cacheKey
            )
            .id(colorScheme)
            .ignoresSafeArea(.container, edges: [.top, .bottom])
            .opacity(viewStatus == .done ? 1 : 0)
        }
    }
}

private extension MMWebView {
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

