import FeedLibrary
import Foundation

// MARK: - Preview Helpers

/// Sample data for SwiftUI previews only
#if DEBUG
enum PreviewData {

    // MARK: - Sample Posts

    static func samplePost(
        id: String = "1",
        title: String = "Apple Intelligence: tudo sobre a nova IA da Apple",
        favorite: Bool = false,
        categories: [String] = ["Destaques"]
    ) -> FeedDB {
        FeedDB(
            postId: id,
            title: title,
            subtitle: "Subtítulo da notícia",
            pubDate: Date().addingTimeInterval(-3600),
            artworkURL: "https://picsum.photos/id/\(Int.random(in: 100...500))/800/450",
            link: "https://www.macmagazine.com/",
            categories: categories,
            excerpt: "Este é um resumo da notícia com informações relevantes para os leitores.",
            fullContent: "Conteúdo completo...",
            favorite: favorite
        )
    }

    static var sampleHighlights: [FeedDB] {
        (1...10).map { index in
            samplePost(
                id: "highlight_\(index)",
                title: "Destaque \(index): Novidade importante da Apple",
                favorite: index % 3 == 0,
                categories: ["Destaques"]
            )
        }
    }

    static var sampleNews: [FeedDB] {
        (1...20).map { index in
            samplePost(
                id: "news_\(index)",
                title: "Notícia \(index): Atualização sobre produtos Apple",
                favorite: index % 5 == 0,
                categories: ["Últimas Notícias"]
            )
        }
    }

    static var sampleFavorites: [FeedDB] {
        (1...5).map { index in
            samplePost(
                id: "fav_\(index)",
                title: "Favorito \(index): Post salvo pelo usuário",
                favorite: true,
                categories: ["Últimas Notícias"]
            )
        }
    }
}
#endif
