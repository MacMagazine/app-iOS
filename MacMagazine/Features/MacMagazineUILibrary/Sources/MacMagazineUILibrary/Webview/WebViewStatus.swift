import SwiftUI

enum WebViewStatus: Equatable {
    case idle
    case loading
    case error(String)
    case done
}

struct WebViewStatusOverlay: View {
    let status: WebViewStatus

    var body: some View {
        switch status {
        case .loading:
            ProgressView()
                .accessibilityLabel("Carregando conteúdo")
        case let .error(error):
            ContentUnavailableView(
                "Estamos com um problema",
                systemImage: "wifi.exclamationmark",
                description: Text(error)
            )
        default: EmptyView()
        }
    }
}
