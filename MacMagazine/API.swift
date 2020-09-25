//
//  API.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 27/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

struct Category: Codable {
    var title: String = ""
    var parent: String = ""
    var order: Int = 0
    var id: Int = 0
}

// MARK: - Extensions -

extension URL {

    enum Address {
        static let disqus = API.APIParams.disqus
        static let macmagazine = API.APIParams.mmDomain
        static let blank = "about:blank"
    }

    func isKnownAddress() -> Bool {
        return self.absoluteString.contains(Address.disqus) ||
            self.absoluteString.contains(Address.macmagazine)
    }

    func isMMAddress() -> Bool {
        return self.absoluteString.contains(Address.macmagazine)
    }

    func isDisqusAddress() -> Bool {
        return self.absoluteString.contains(Address.disqus)
    }

    func isBlankAddress() -> Bool {
        return self.absoluteString.contains(Address.blank)
    }

}

class API {

	// MARK: - Definitions -

	enum APIParams {
		// Disqus
		static let disqus = "disqus.com"

        // Wordpress
        static let mmDomain = "macmagazine.uol.com.br"
        static let mm = "https://\(mmDomain)/"
		static let feed = "\(mm)feed/"
        static let patrao = "\(mm)loginpatrao"
		static let paged = "paged="
		static let cat = "cat="
		static let posts = "\(cat)-101"
		static let podcast = "\(cat)101"
		static let search = "s="
        static let restAPI = "\(mm)wp-json/menus/v2/"
        static let categories = "categories"
		static let tag = "tag="

		// YouTube
		static let salt = "AppDelegateNSObject"
		static let keyParam = "key="
		static let key: [UInt8] = [0, 57, 10, 37, 54, 21, 36, 2, 13, 46, 93, 125, 43, 45, 86, 5, 55, 5, 57, 59, 9, 58, 118, 32, 5, 12, 4, 51, 36, 52, 36, 60, 62, 9, 91, 36, 54, 30, 50]

		static let youtubeURL = "https://www.googleapis.com/youtube/v3"
		static let sort = "order=date"

		static let playlistItems = "\(youtubeURL)/playlistItems"
		static let playlistPart = "part=snippet"

		static let playlistIdParam = "playlistId="
		static let playlistId: [UInt8] = [20, 37, 70, 30, 44, 1, 41, 16, 8, 61, 4, 24, 1, 22, 43, 45, 28, 0, 5, 41, 69, 25, 8, 36]

		static let maxResults = "maxResults=15"
		static let pageToken = "pageToken="

		static let statistics = "\(youtubeURL)/videos"
		static let statisticsPart = "part=statistics,contentDetails"
		static let videoId = "id="

		static let videoSearch = "\(youtubeURL)/search"
		static let videoSearchPart = "part=snippet"
		static let videoQuery = "q="

		static let channel = "channelId="
		static let channelId: [UInt8] = [20, 51, 70, 30, 44, 1, 41, 16, 8, 61, 4, 24, 1, 22, 43, 45, 28, 0, 5, 41, 69, 25, 8, 36]
	}

	// MARK: - Properties -

    var onCompletion: ((XMLPost?) -> Void)?
	var isComplication = false

	#if os(iOS)
	var onVideoCompletion: ((YouTube<String>?) -> Void)?
	var onVideoSearchCompletion: ((YouTube<ResourceId>?) -> Void)?
	#endif

    // MARK: - Public methods -

    func getMMURL() -> String {
        return APIParams.mm
    }

    func getCookies(_ domain: String? = nil) -> [HTTPCookie]? {
        let cookies = HTTPCookieStorage.shared.cookies

        guard let domain = domain else {
            return cookies
        }

        return cookies?.filter {
            return $0.domain.contains(domain)
        }
	}

    func getDisqusCookies() -> [HTTPCookie] {
        return getCookies(APIParams.disqus) ?? []
    }

    func getMMCookies() -> [HTTPCookie] {
        return getCookies(APIParams.mmDomain) ?? []
    }

    func cleanCookies() {
		for cookie in getCookies() ?? [] {
			if !cookie.domain.contains(APIParams.disqus) &&
                !cookie.domain.contains(APIParams.mmDomain) {
                HTTPCookieStorage.shared.deleteCookie(cookie)
			}
		}
	}

	func getComplications(_ completion: ((XMLPost?) -> Void)?) {
		isComplication = true
		getPosts(page: 0, completion)
	}

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

    func searchPosts(category: String, _ completion: ((XMLPost?) -> Void)?) {
        onCompletion = completion
		let host = "\(APIParams.feed)?\(APIParams.tag)'\(category.replacingOccurrences(of: " ", with: "-"))'"
        executeGetContent(host)
    }

	func searchPodcasts(_ text: String, _ completion: ((XMLPost?) -> Void)?) {
		onCompletion = completion
		let host = "\(APIParams.feed)?\(APIParams.podcast)&\(APIParams.search)'\(text)'"
		executeGetContent(host)
	}

    func getCategories(_ completion: (([Category]?) -> Void)?) {
        let host = "\(APIParams.restAPI)\(APIParams.categories)"

        guard let url = URL(string: "\(host.escape())") else {
            return
        }

        Network.get(url: url) { (data: Data?, _: String?) in
            guard let data = data,
                let categories = self.decodeJSON(data)
            else {
                completion?(nil)
                return
            }
            DispatchQueue.main.async {
                completion?(categories)
            }
        }
    }

    // MARK: - Internal methods -

    fileprivate func decodeJSON(_ data: Data) -> [Category]? {
        let decoder = JSONDecoder()

        do {
            return try decoder.decode([Category].self, from: data)

        } catch {
            return nil
        }
    }

    fileprivate func executeGetContent(_ host: String) {
		cleanCookies()

        guard let url = URL(string: "\(host.escape())") else {
            return
        }

        Network.get(url: url) { (data: Data?, _: String?) in
            guard let data = data else {
				self.onCompletion?(nil)
                return
            }
            self.parse(data, onCompletion: self.onCompletion, isComplication: self.isComplication)
        }
    }

}

extension API {
	func parse(_ data: Data, onCompletion: ((XMLPost?) -> Void)?, isComplication: Bool) {
		let parser = XMLParser(data: data)
		let apiParser = APIXMLParser(onCompletion: onCompletion, isComplication: isComplication)
		parser.delegate = apiParser
		parser.parse()
	}
}
