import Foundation

class APIXMLParser: NSObject, XMLParserDelegate {

	// MARK: - Properties -

	let numberOfPosts: Int
	var parseFullContent: Bool
	let continuation: CheckedContinuation<[XMLPost], Error>?

	var posts = [XMLPost]()

	var currentPost = XMLPost()
	var processItem = false
	var value = ""
	var attributes: [String: String]?
	var parsedPosts = 0

	// MARK: - Init -

	init(numberOfPosts: Int = -1,
		 parseFullContent: Bool = false,
		 continuation: CheckedContinuation<[XMLPost], Error>?) {
		self.numberOfPosts = numberOfPosts
		self.parseFullContent = parseFullContent
		self.continuation = continuation
	}

	// MARK: - Parse Delegate -

	func parser(_ parser: XMLParser,
				didStartElement elementName: String,
				namespaceURI: String?,
				qualifiedName qName: String?,
				attributes attributeDict: [String: String] = [:]) {

		value = ""
		if elementName == "item" {
			processItem = true
			currentPost = XMLPost()
		}
		if elementName == "media:content" {
			attributes = attributeDict
		}
		if elementName == "enclosure" {
			attributes = attributeDict
		}
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {
		if processItem {
			value += string
		}
	}

	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if processItem {
			value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

			switch elementName {
			case "post-id":
				currentPost.postId = value
			case "title":
				currentPost.title = value
			case "link":
				currentPost.link = value
			case "pubDate":
				currentPost.pubDate = value.toDate(timeZone: TimeZone(abbreviation: "UTC"),
												   locale: "en_US")
			case "category":
				if currentPost.categories.isEmpty {
					currentPost.categories = []
				}
				currentPost.categories.append(value)
			case "description":
				currentPost.excerpt = value
			case "media:content":
				guard let url = attributes?["url"] else {
					return
				}
				currentPost.artworkURL = url
			case "enclosure":
				guard let url = attributes?["url"] else {
					return
				}
				currentPost.podcastURL = url
			case "itunes:subtitle":
				currentPost.podcast = value
			case "itunes:duration":
				currentPost.duration = value
			case "rawvoice:embed":
				currentPost.podcastFrame = value
			case "item":
				posts.append(currentPost)
				parsedPosts += 1
				processItem = false
				if numberOfPosts > 0 &&
					parsedPosts >= numberOfPosts {
					parser.abortParsing()
				}
			case "guid":
				currentPost.shortURL = value
			case "content:encoded":
				currentPost.playable = value.contains("youtube.com/embed/")
				currentPost.fullContent = parseFullContent ? value.htmlDecoded.clean : ""
			default:
				return
			}
		}
	}

	func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
		if posts.count == numberOfPosts {
			continuation?.resume(returning: posts)
		} else {
			continuation?.resume(throwing: parseError)
		}
	}

	func parserDidEndDocument(_ parser: XMLParser) {
		continuation?.resume(returning: posts)
	}
}
