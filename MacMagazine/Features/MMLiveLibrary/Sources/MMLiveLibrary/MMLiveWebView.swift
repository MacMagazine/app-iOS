import Foundation
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
#if canImport(UIKit)
import UIKit
#endif

public struct MMLiveWebView: View {
    private let darkMode: Bool

    public init(
        colorSchema: ColorScheme?
    ) {
        self.darkMode = if colorSchema == nil {
            Self.isDarkMode()
        } else {
            colorSchema == .dark
        }
    }

    public var body: some View {
        Webview(
            url: "https://macmagazine.com.br/live",
            isPresenting: .constant(false),
            standAlone: true,
            cookies: makeCookies(),
            userAgent: "/MacMagazine"
        )
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

private extension MMLiveWebView {
    func makeCookies() -> [HTTPCookie]? {
        var cookies = [HTTPCookie]()
        if let darkMode = Cookies.createDarkMode(darkMode ? "true" : "false") {
            cookies.append(darkMode)
        }
        return cookies
    }
}

#if canImport(UIKit)
private extension MMLiveWebView {
    static func isDarkMode() -> Bool {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?
            .rootViewController?
            .traitCollection.userInterfaceStyle == .dark
    }
}
#else
private extension MMLiveWebView {
    static func isDarkMode() -> Bool {
        false
    }
}
#endif
