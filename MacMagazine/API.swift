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
		// Wordpress
		static let feed = "https://macmagazine.uol.com.br/feed/"
		static let paged = "paged="
		static let posts = "cat=-101"
		static let podcast = "cat=101"
		static let search = "s="

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
		static let statisticsPart = "part=statistics"
		static let videoId = "id="

		static let videoSearch = "\(youtubeURL)/search"
		static let videoSearchPart = "part=snippet"
		static let videoQuery = "q="

		static let channel = "channelId="
		static let channelId: [UInt8] = [20, 51, 70, 30, 44, 1, 41, 16, 8, 61, 4, 24, 1, 22, 43, 45, 28, 0, 5, 41, 69, 25, 8, 36]
	}

	// MARK: - Properties -

    var onCompletion: ((XMLPost?) -> Void)?
    var currentPost = XMLPost()
    var processItem = false
    var value = ""
    var attributes: [String: String]?
	var isComplication = false

	#if os(iOS)
	var onVideoCompletion: ((YouTube<String>?) -> Void)?
	var onVideoSearchCompletion: ((YouTube<ResourceId>?) -> Void)?
	#endif

    // MARK: - Public methods -

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

        guard let url = URL(string: "\(host.escape())") else {
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
