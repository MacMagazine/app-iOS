import FeedLibrary
import SwiftUI
import UIComponentsLibrary

extension View {
    func peekAndPop(
        item: FeedDB,
        open: ((FeedDB) -> Void)?,
        favorite: (() -> Void)?,
        read: (() -> Void)?
    ) -> some View {
        modifier(PeekPopModifier(
            item: item,
            open: open,
            favorite: favorite,
            read: read
        ))
    }
}

private struct PeekPopModifier: ViewModifier {
    let item: FeedDB
    let open: ((FeedDB) -> Void)?
    let favorite: (() -> Void)?
    let read: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .contextMenu {
                openPost
                readPost
                favoritePost
                sharePost
            } preview: {
                Webview(
                    url: item.link,
                    isPresenting: .constant(true),
                    standAlone: true,
                    userAgent: "/MacMagazine",
                    cacheKey: "macmagazine-preview"
                )
            }
    }
}

private extension PeekPopModifier {
    @ViewBuilder
    var openPost: some View {
        if let open {
            Button { open(item) }
            label: { Label("Abrir post", systemImage: "newspaper") }
        }
    }

    @ViewBuilder
    var favoritePost: some View {
        if let favorite {
            Button { favorite() }
            label: { Label("Favorito", systemImage: favoriteImage) }
        }
    }

    @ViewBuilder
    var sharePost: some View {
        if let url = URL(string: item.link) {
            ShareLink(item: url, subject: Text(item.title)) {
                Label("Compartilhar", systemImage: "square.and.arrow.up")
            }
        }
    }

    @ViewBuilder
    var readPost: some View {
        if let read {
            Button { read() }
            label: { Label(readText, systemImage: readImage) }
        }
    }
}

private extension PeekPopModifier {
    var favoriteImage: String {
        item.favorite ? "star.fill" : "star"
    }

    var readText: String {
        item.read ? "Marcar como não lido" : "Marcar como lido"
    }

    var readImage: String {
        item.read ? "circle" : "circle.fill"
    }
}
