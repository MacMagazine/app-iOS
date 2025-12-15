import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import WebKit
#if canImport(UIKit)
import UIKit
#endif

struct InstagramPostsWebView: View {
    let url: URL
    let userAgent: String
    let shouldUseSidebar: Bool

    private let darkMode: Bool

    @Environment(\.theme) private var theme: ThemeColor

    @State private var isPresenting = true
    @State private var isLoading = true
    @State private var loadError: String?

    private let navigationDelegate = InstagramNavigationDelegate()

    init(
        colorSchema: ColorScheme?,
        url: URL,
        userAgent: String,
        shouldUseSidebar: Bool
    ) {
        self.url = url
        self.userAgent = userAgent
        self.shouldUseSidebar = shouldUseSidebar

        self.darkMode = if colorSchema == nil {
            Self.isDarkMode()
        } else {
            colorSchema == .dark
        }
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

            Webview(
                title: nil,
                url: url.absoluteString,
                isPresenting: $isPresenting,
                standAlone: true,
                navigationDelegate: navigationDelegate,
                userScripts: userScripts,
                cookies: makeCookies(),
                userAgent: userAgent
            )
            .ignoresSafeArea(.container, edges: [.top, .bottom])
            .opacity(isLoading ? 0 : 1)
            .animation(.easeInOut(duration: 0.25), value: isLoading)

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
            navigationDelegate.onStart = { isLoading = true; loadError = nil }
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

private extension InstagramPostsWebView {
    func makeCookies() -> [HTTPCookie]? {
        var cookies = [HTTPCookie]()
        if let darkMode = Cookies.createDarkMode(darkMode ? "true" : "false") {
            cookies.append(darkMode)
        }
        return cookies
    }
}

#if canImport(UIKit)
private extension InstagramPostsWebView {
    static func isDarkMode() -> Bool {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?
            .rootViewController?
            .traitCollection.userInterfaceStyle == .dark
    }
}
#else
private extension InstagramPostsWebView {
    static func isDarkMode() -> Bool {
        false
    }
}
#endif
