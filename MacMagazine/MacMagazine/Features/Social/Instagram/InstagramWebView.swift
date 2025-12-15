import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import WebKit

struct InstagramWebView: View {
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar
    @Environment(\.theme) private var theme: ThemeColor

    @State private var isPresenting = true
    @State private var isLoading = true
    @State private var loadError: String?

    private let instagram = "https://macmagazine.com.br/posts-instagram-app/"
    private let navigationDelegate = InstagramNavigationDelegate()
    private let darkMode: Bool

    init(colorSchema: ColorScheme?) {
        self.darkMode = Utils.isDarkMode(for: colorSchema)
    }

    private var userScripts: [WKUserScript] {
        [
            WKUserScript(
                source: """
                (function() {
                  var style = document.createElement('style');
                  style.innerHTML = `
                    html, body {
                      padding-top: 50px !important;
                    }
                  `;
                  document.head.appendChild(style);
                })();
                """,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: true
            )
        ]
    }

    var body: some View {
        ZStack {
            (theme.main.background.color ?? Color.secondary)
                .ignoresSafeArea()

            content
                .transition(.opacity)

            if isLoading {
                ProgressView()
                    .transition(.opacity)
            }

            if loadError != nil {
                ContentUnavailableView(
                    "Estamos com um problema",
                    systemImage: "square.and.arrow.down.badge.xmark",
                    description: Text("No momento estamos com um problema técnico. Tente novamente mais tarde.")
                )
            }
        }
        .onAppear {
            navigationDelegate.onStart = {
                isLoading = true
                loadError = nil
            }
            navigationDelegate.onFinish = {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    isLoading = false
                }
            }
            navigationDelegate.onFail = { error in
                isLoading = false
                loadError = error.localizedDescription
            }
        }
    }
}

private extension InstagramWebView {
    @ViewBuilder
    var content: some View {
        if URL(string: instagram) != nil {
            webview
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

    var webview: some View {
        Webview(
            title: nil,
            url: instagram,
            isPresenting: $isPresenting,
            standAlone: true,
            navigationDelegate: navigationDelegate,
            userScripts: userScripts,
            cookies: Cookies.makeCookies(darkMode: darkMode),
            userAgent: Utils.userAgent
        )
        .ignoresSafeArea(.container, edges: [.top, .bottom])
        .opacity(isLoading ? 0 : 1)
        .animation(.easeInOut(duration: 0.25), value: isLoading)
    }
}
