//
//  API.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 27/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Foundation

class API: NSObject, XMLParserDelegate {

	// MARK: - Definitions -

	enum APIParams {
		static let feed = "https://macmagazine.uol.com.br/feed/"
		static let paged = "paged="
		static let posts = "cat=-101"
		static let podcast = "cat=101"
		static let search = "s="
	}

	// MARK: - Properties -

    var onCompletion: ((XMLPost?) -> Void)?
    var currentPost = XMLPost()
    var processItem = false
    var value = ""
    var attributes: [String: String]?

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
        Network.get(url: url) { (data: Data?, _: String?) in
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
