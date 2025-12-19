import Foundation

public struct WidgetData: Codable, Hashable {
    public let postId: String
    public let title: String
    public let thumbnail: String
    public let pubDate: Date
    public let link: String
    public let imageData: Data?

    public init(
        postId: String,
        title: String,
        thumbnail: String,
        pubDate: Date,
        link: String,
        imageData: Data? = nil
    ) {
        self.postId = postId
        self.title = title
        self.thumbnail = thumbnail
        self.pubDate = pubDate
        self.link = link
        self.imageData = imageData
    }
}
