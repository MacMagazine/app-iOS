import Foundation
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public struct MMLiveWebView: View {
    private let darkMode: Bool

    public init(colorSchema: ColorScheme?) {
        self.darkMode = Utils.isDarkMode(for: colorSchema)
    }

    public var body: some View {
        Webview(
            url: "https://macmagazine.com.br/live",
            isPresenting: .constant(false),
            standAlone: true,
            cookies: Cookies.makeCookies(darkMode: darkMode),
            userAgent: Utils.userAgent
        )
        .ignoresSafeArea(.container, edges: .bottom)
    }
}
