//
//  API.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 27/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class API: NSObject, XMLParserDelegate {

	// MARK: - Definitions -

	enum APIParams {
		static let feed = "https://macmagazine.uol.com.br/feed/"
		static let paged = "paged="
		static let posts = "cat=-101"
		static let podcast = "cat=101"
		static let search = "s="

		static let playlistItems = "https://www.googleapis.com/youtube/v3/playlistItems"
		static let playlistPart = "part=snippet"
		static let playlistIdParam = "playlistId="
		static let playlistId: [UInt8] = [20, 37, 70, 30, 44, 1, 41, 16, 8, 61, 4, 24, 1, 22, 43, 45, 28, 0, 5, 41, 69, 25, 8, 36]
		static let keyParam = "key="
		static let key: [UInt8] = [0, 57, 10, 37, 54, 21, 39, 43, 50, 70, 46, 33, 50, 24, 1, 39, 85, 7, 43, 19, 61, 27, 117, 2, 52, 82, 5, 37, 69, 48, 27, 21, 29, 26, 38, 92, 10, 68, 50]
		static let salt = "AppDelegateNSObject"
		static let maxResults = "maxResults=15"
		static let pageToken = "pageToken="
	}

	// MARK: - Properties -

    var onCompletion: ((XMLPost?) -> Void)?
    var currentPost = XMLPost()
    var processItem = false
    var value = ""
    var attributes: [String: String]?

	var onVideoCompletion: ((YouTube?) -> Void)?

    // MARK: - Public methods -

    func getPosts(page: Int = 0, _ completion: ((XMLPost?) -> Void)?) {
        onCompletion = completion
        let host = "\(APIParams.feed)?\(APIParams.paged)\(page)"
        executeGetContent(host)
    }

    func getPodcasts(page: Int = 0, _ completion: ((XMLPost?) -> Void)?) {
        onCompletion = completion
        let host = "\(APIParams.feed)?\(APIParams.podcast)&\(APIParams.paged)\(page)"
        executeGetContent(host)
    }

    func searchPosts(_ text: String, _ completion: ((XMLPost?) -> Void)?) {
        onCompletion = completion
        let host = "\(APIParams.feed)?\(APIParams.search)'\(text)'"
        executeGetContent(host)
    }

	func searchPodcasts(_ text: String, _ completion: ((XMLPost?) -> Void)?) {
		onCompletion = completion
		let host = "\(APIParams.feed)?\(APIParams.podcast)&\(APIParams.search)'\(text)'"
		executeGetContent(host)
	}

    // MARK: - Internal methods -

    fileprivate func executeGetContent(_ host: String) {
        let cookieStore = HTTPCookieStorage.shared
        for cookie in cookieStore.cookies ?? [] {
            cookieStore.deleteCookie(cookie)
        }

        guard let url = URL(string: "\(host)") else {
            return
        }

		#if os(iOS)
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		#endif
        Network.get(url: url) { (data: Data?, _: String?) in
			#if os(iOS)
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}
			#endif

            guard let data = data else {
				self.onCompletion?(nil)
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
    }

}

struct XMLPost {
    var title: String = ""
    var link: String = ""
    var pubDate: String = ""
    var categories: [String] = []
    var excerpt: String = ""
    var artworkURL: String = ""
    var podcastURL: String = ""
    var podcast: String = ""
    var duration: String = ""
    var podcastFrame: String = ""

    fileprivate func decodeHTMLString(string: String) -> String {
        guard let encodedData = string.data(using: String.Encoding.utf8) else {
            return ""
        }
        do {
            return try NSAttributedString(data: encodedData, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string
        } catch {
             return error.localizedDescription
        }
    }

	func getCategorias() -> String {
        return self.categories.joined(separator: ",")
    }
}

extension API {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {

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
            case "title":
                currentPost.title = value
            case "link":
                currentPost.link = value
            case "pubDate":
                currentPost.pubDate = value
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
                onCompletion?(currentPost)
                processItem = false
            default:
                return
            }
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
        onCompletion?(nil)
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        onCompletion?(nil)
    }

}

struct YouTube: Codable {
	var kind: String?
	var etag: String?
	var nextPageToken: String?
	var pageInfo: PageInfo?
	var items: [Item]?
}

struct PageInfo: Codable {
	var totalResults: Int?
	var resultsPerPage: Int?
}

struct Item: Codable {
	var kind: String?
	var etag: String?
	var id: String?
	var snippet: Snippet?
	var statistics: Statistics?
}

struct Snippet: Codable {
	var publishedAt: String?
	var channelId: String?
	var title: String?
	var description: String?
	var thumbnails: Thumbnails?
	var channelTitle: String?
	var playlistId: String?
	var position: Int
	var resourceId: ResourceId?
}

struct ResourceId: Codable {
	var kind: String?
	var videoId: String?
}

struct Thumbnails: Codable {
	var original: MediaInfo?
	var medium: MediaInfo?
	var high: MediaInfo?
	var standard: MediaInfo?
	var maxres: MediaInfo?

	private enum CodingKeys: String, CodingKey {
		case original = "default", medium, high, standard, maxres
	}
}

struct MediaInfo: Codable {
	var url: String?
	var width: Int
	var height: Int
}

struct Statistics: Codable {
	var viewCount: String?
	var likeCount: String?
	var dislikeCount: String?
	var favoriteCount: String?
	var commentCount: String?
}

#if os(iOS)
// MARK: - Videos Methods -

extension API {

	func getVideos( _ completion: ((YouTube?) -> Void)?) {
		onVideoCompletion = completion

		let obfuscator = Obfuscator(with: APIParams.salt)
		let playlistId = obfuscator.reveal(key: APIParams.playlistId)
		let key = obfuscator.reveal(key: APIParams.key)

		var pageToken = ""
		if let nextToken = Settings().getVideoNextToken() {
			pageToken = "&\(APIParams.pageToken)\(nextToken)"
		}

		let host = "\(APIParams.playlistItems)?\(APIParams.playlistPart)&\(APIParams.playlistIdParam)\(playlistId)&\(APIParams.keyParam)\(key)&\(APIParams.maxResults)\(pageToken)"
		executeGetVideoContent(host)
	}

	fileprivate func executeGetVideoContent(_ host: String) {
		let cookieStore = HTTPCookieStorage.shared
		for cookie in cookieStore.cookies ?? [] {
			cookieStore.deleteCookie(cookie)
		}

		guard let url = URL(string: "\(host)") else {
			return
		}

		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		Network.getVdeos(url: url) { (data: Data?, _: String?) in
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}

			guard let data = data else {
				self.onVideoCompletion?(nil)
				return
			}

			do {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				decoder.dateDecodingStrategy = .iso8601

				let response = try decoder.decode(YouTube.self, from: data)
				self.onVideoCompletion?(response)

			} catch {
				self.onVideoCompletion?(nil)
			}

		}
	}

}
#endif
