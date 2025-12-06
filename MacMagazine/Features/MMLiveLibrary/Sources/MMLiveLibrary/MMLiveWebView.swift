import SwiftUI
import UIComponentsLibrary

public struct MMLiveWebView: View {
    public init() {}

    public var body: some View {
        content
    }
}

private extension MMLiveWebView {
    @ViewBuilder
    var content: some View {
        Webview(url: "https://macmagazine.com.br/live", isPresenting: .constant(true))
    }

    var contentUnavailableView: some View {
        ContentUnavailableView(
            "Página não existente",
            systemImage: "network.slash",
            description: Text("Erro ao abrir a URL macmagazine.com.br/live.")
        )
    }
}
