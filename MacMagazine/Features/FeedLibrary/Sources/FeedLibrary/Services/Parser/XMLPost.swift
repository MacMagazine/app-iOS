import Foundation

struct XMLPost: Codable {
	var title: String = ""
	var link: String = ""
	var pubDate: Date = Date()
	var categories: [String] = []
	var excerpt: String = ""
	var artworkURL: String = ""
	var podcastURL: String = ""
    var podcastSize: Double = 0
	var podcast: String = ""
	var duration: String = ""
	var podcastFrame: String = ""
	var favorite: Bool = false
	var postId: String = ""
	var shortURL: String = ""
	var playable: Bool = false
	var fullContent: String = ""
	var creator: String = ""
}

extension Array where Element == XMLPost {
    var toPodcastDB: [PodcastDB] {
        self.map {
            PodcastDB(
                postId: $0.postId,
                title: $0.title,
                subtitle: $0.podcast,
                pubDate: $0.pubDate,
                artworkURL: $0.artworkURL,
                podcastURL: $0.podcastURL,
                podcastSize: $0.podcastSize,
                duration: $0.duration,
                podcastFrame: $0.podcastFrame
            )
        }
    }
}
