import Foundation
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public struct MMWebView: View {
    enum WebViewStatus: Equatable {
        case idle
        case loading
        case error(String)
        case done
    }

    @Environment(\.removeAds) private var removeAds
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.theme) private var theme: ThemeColor

    @State private var viewStatus = WebViewStatus.idle

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
            statusView
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
        }
    }
}

private extension MMWebView {
    @ViewBuilder
    var statusView: some View {
        switch viewStatus {
        case .loading:
            ProgressView()
        case let .error(error):
            ContentUnavailableView(
                "Estamos com um problema",
                systemImage: "wifi.exclamationmark",
                description: Text(error)
            )
        default: EmptyView()
        }
    }

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
                    MMWebViewUserScripts.comments,
                    MMWebViewUserScripts.removeBackToBlog
                ],
                cookies: makeCookies(using: colorScheme),
                scriptMessageHandlers: [
                    (controller, "imageTappedHandler"),
                    (controller, "gotCommentURLHandler")
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
