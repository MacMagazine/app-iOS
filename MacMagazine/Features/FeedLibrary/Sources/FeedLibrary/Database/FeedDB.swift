import Foundation
import MacMagazineLibrary
import SwiftData

@Model
public final class FeedDB {
    public var postId: String = ""
    public var title: String = ""
    public var subtitle: String = ""
    public var pubDate: Date = Date()
    public var artworkURL: String = ""
    public var link: String = ""
    public var categories: [String] = []
    public var excerpt: String = ""
    public var fullContent: String = ""
    public var favorite: Bool = false

    public init(
        postId: String = "",
        title: String = "",
        subtitle: String = "",
        pubDate: Date = Date(),
        artworkURL: String = "",
        link: String = "",
        categories: [String] = [],
        excerpt: String = "",
        fullContent: String = "",
        favorite: Bool = false
    ) {
        self.postId = postId
        self.title = title
        self.subtitle = subtitle
        self.pubDate = pubDate
        self.artworkURL = artworkURL
        self.link = link
        self.categories = categories
        self.excerpt = excerpt
        self.fullContent = fullContent
        self.favorite = favorite
    }
}

extension FeedDB: ModelFavoritable {
    public static func deleteNonFavorites(using context: ModelContext?) {
        let descriptor = FetchDescriptor(predicate: #Predicate<FeedDB> { !$0.favorite })
        guard let context,
              let data = try? context.fetch(descriptor) else { return }
        data.forEach { context.delete($0) }
        try? context.save()
    }
}
