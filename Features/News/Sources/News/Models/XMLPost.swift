import Foundation

struct XMLPost: Codable {
	var title: String = ""
	var link: String = ""
	var pubDate: Date = Date()
	var categories: [String] = []
	var excerpt: String = ""
	var artworkURL: String = ""
	var podcastURL: String = ""
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
