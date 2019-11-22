//
//  XMLParser.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 15/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

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
	var favorite: Bool = false
	var guid: String = ""
	var postId: String = ""

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

class APIXMLParser: NSObject, XMLParserDelegate {

	// MARK: - Properties -

	var onCompletion: ((XMLPost?) -> Void)?
	var currentPost = XMLPost()
	var processItem = false
	var value = ""
	var attributes: [String: String]?
	var isComplication = false

	// MARK: - Init -

	init(onCompletion: ((XMLPost?) -> Void)?, isComplication: Bool) {
		self.onCompletion = onCompletion
		self.isComplication = isComplication
	}

	// MARK: - Parse Delegate -

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
			case "post-id":
				currentPost.postId = value
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
				if isComplication {
					parser.abortParsing()
				}
			case "guid":
				currentPost.guid = value
			default:
				return
			}
		}
	}

	func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
		onCompletion?(nil)
	}

	func parserDidEndDocument(_ parser: XMLParser) {
		onCompletion?(nil)
	}

}
