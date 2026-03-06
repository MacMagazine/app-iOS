import SwiftUI

public struct MenuButton: View {
    private let data: CardContent

    public init(data: CardContent) {
        self.data = data
    }

    public var body: some View {
        Menu(content: {
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
        }, label: {
            Image(systemName: "ellipsis").buttonWithGlassEffect()
        })
        .accessibilityLabel("Abrir menu de opções.")
    }
}

private extension MenuButton {
    var favoriteImage: String {
        data.favorite ? "star.fill" : "star"
    }

    var readImage: String {
        data.read ? "circle.fill" : "circle"
    }
}
