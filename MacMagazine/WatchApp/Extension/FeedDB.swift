import FeedLibrary
import Foundation

extension FeedDB {
    var linkURL: URL? {
        guard !link.isEmpty else { return nil }
        return URL(string: link)
    }

    var dateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "dd/MM/yyyy 'às' HH:mm"
        return formatter.string(from: pubDate)
    }

    var displaySubtitle: String? {
        let subtitle = subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
        return subtitle.isEmpty ? nil : subtitle
    }

    var displayBody: String? {
        let full = fullContent.trimmingCharacters(in: .whitespacesAndNewlines)
        if !full.isEmpty { return full }

        let excerpt = excerpt.trimmingCharacters(in: .whitespacesAndNewlines)
        return excerpt.isEmpty ? nil : excerpt
    }

    var artworkRemoteURL: URL? {
        guard !artworkURL.isEmpty else { return nil }
        return URL(string: artworkURL)
    }

    static var previewItem: FeedDB {
        FeedDB(
            postId: UUID().uuidString,
            title: "Apple lança atualização do watchOS",
            subtitle: "Mudanças importantes para o Apple Watch",
            pubDate: Date().addingTimeInterval(-3600),
            artworkURL: "https://picsum.photos/400/400",
            link: "https://macmagazine.com.br",
            categories: ["watchos", "news", "teste1", "teste2", "teste 3"],
            excerpt: "Resumo curto para teste no relógio…",
            fullContent: "",
            favorite: false
        )
    }

    static var previewItems: [FeedDB] {
        (1...10).map { index in
            FeedDB(
                postId: UUID().uuidString,
                title: "Notícia \(index): título de teste para o Watch",
                subtitle: "Subtítulo \(index)",
                pubDate: Date().addingTimeInterval(TimeInterval(-index * 900)),
                artworkURL: "https://picsum.photos/seed/\(index)/600/600",
                link: "https://macmagazine.com.br",
                categories: ["news", "teste1", "teste2", "teste 3"],
                excerpt: "Excerpt \(index) – texto curto para validar layout.",
                fullContent: "",
                favorite: index % 3 == 0
            )
        }
    }
}
