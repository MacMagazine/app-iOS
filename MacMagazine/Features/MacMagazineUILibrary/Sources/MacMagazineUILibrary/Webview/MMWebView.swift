import Foundation
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public struct MMWebView: View {
    @Environment(\.removeAds) private var removeAds
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.theme) private var theme: ThemeColor

    @State private var isLoading = false
    @State private var loadError: String?

    private let controller = MMWebViewController()
    private let url: String?

    public init(url: String?) {
        self.url = url
    }

    public var body: some View {
        ZStack {
            (theme.main.background.color ?? Color.secondary)
                .ignoresSafeArea()

            content.transition(.opacity)

            if isLoading {
                ProgressView().transition(.opacity)
            }

            if loadError != nil {
                ContentUnavailableView(
                    "Estamos com um problema",
                    systemImage: "square.and.arrow.down.badge.xmark",
                    description: Text("No momento estamos com um problema técnico. Tente novamente mais tarde.")
                )
            }
        }
        .task {
            controller.onStart = {
                isLoading = true
                loadError = nil
            }
            controller.onFinish = {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    isLoading = false
                }
            }
            controller.onFail = { error in
                isLoading = false
                loadError = error.localizedDescription
            }
        }
    }
}

private extension MMWebView {
    @ViewBuilder
    var content: some View {
        if let url {
            webview(url: url)
        } else {
            ContentUnavailableView(
                "Estamos com um problema",
                systemImage: "square.and.arrow.down.badge.xmark",
                description: Text(
                    "No momento estamos com um problema técnico. Tente novamente mais tarde."
                )
            )
        }
    }

    func webview(url: String) -> some View {
        Webview(
            url: url,
            isPresenting: .constant(true),
            standAlone: true,
            navigationDelegate: controller,
            userScripts: [MMWebViewUserScripts.topPadding],
            cookies: makeCookies(using: colorScheme),
            userAgent: Utils.userAgent
        )
        .id(colorScheme)
        .ignoresSafeArea(.container, edges: [.top, .bottom])
        .opacity(isLoading ? 0 : 1)
        .animation(.easeInOut(duration: 0.25), value: isLoading)
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
