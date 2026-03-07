import SwiftUI

public struct MenuButton: View {
    private let data: CardContent

    public init(data: CardContent) {
        self.data = data
    }

    public var body: some View {
        Menu(content: {
            MenuContent(data: data)
        }, label: {
            Image(systemName: "ellipsis").buttonWithGlassEffect()
        })
        .accessibilityLabel("Abrir menu de opções.")
    }
}

public struct MenuContent: View {
    private let data: CardContent

    public init(data: CardContent) {
        self.data = data
    }

    public var body: some View {
        Button("Favorito", systemImage: favoriteImage) {
            data.favoriteAction()
        }

        if let url = URL(string: data.urlToShare) {
            ShareLink(item: url, subject: Text(data.title)) {
                Label("Compartilhar", systemImage: "square.and.arrow.up")
            }
        }

        Button("Lido", systemImage: readImage) {
            data.readAction()
        }
    }
}

private extension MenuContent {
    var favoriteImage: String {
        data.favorite ? "star.fill" : "star"
    }

    var readImage: String {
        data.read ? "circle.fill" : "circle"
    }
}
