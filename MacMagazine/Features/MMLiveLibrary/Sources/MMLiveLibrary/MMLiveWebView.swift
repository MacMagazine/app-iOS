import SwiftUI
 import UIComponentsLibrary

public struct MMLiveWebView: View {
    public init() {}

    public var body: some View {
        Webview(
            url: "https://macmagazine.com.br/live",
            isPresenting: .constant(false),
            standAlone: true
        )
        .ignoresSafeArea(.container, edges: .bottom)
    }
}
