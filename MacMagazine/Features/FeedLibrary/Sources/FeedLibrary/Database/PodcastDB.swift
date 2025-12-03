import Foundation
import SwiftData

@Model
public final class PodcastDB {
    public var postId: String = ""
    public var title: String = ""
    public var subtitle: String = ""
    public var pubDate: Date = Date()
    public var artworkURL: String = ""
    public var podcastURL: String = ""
    public var podcastSize: Double = 0
    public var duration: String = ""
    public var podcastFrame: String = ""
    public var favorite: Bool = false
    public var playable: Bool = false

    init(
        postId: String = "",
        title: String = "",
        subtitle: String = "",
        pubDate: Date = Date(),
        artworkURL: String = "",
        podcastURL: String = "",
        podcastSize: Double = 0,
        duration: String = "",
        podcastFrame: String = "",
        favorite: Bool = false,
        playable: Bool = false
    ) {
        self.postId = postId
        self.title = title
        self.subtitle = subtitle
        self.pubDate = pubDate
        self.artworkURL = artworkURL
        self.podcastURL = podcastURL
        self.podcastSize = podcastSize
        self.duration = duration
        self.podcastFrame = podcastFrame
        self.favorite = favorite
        self.playable = playable
    }
}
