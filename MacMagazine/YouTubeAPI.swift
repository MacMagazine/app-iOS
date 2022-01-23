//
//  YouTubeAPI.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 15/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

#if os(iOS)

struct YouTube<T: Codable>: Codable {
	var kind: String?
	var etag: String?
	var nextPageToken: String?
	var regionCode: String?
	var pageInfo: PageInfo?
	var items: [Item<T>]?
}

struct PageInfo: Codable {
	var totalResults: Int?
	var resultsPerPage: Int?
}

struct Item<T: Codable>: Codable {
	var kind: String?
	var etag: String?
	var id: T?
	var snippet: Snippet?
	var statistics: Statistics?
	var contentDetails: Details?
}

struct Snippet: Codable {
	var publishedAt: String?
	var channelId: String?
	var title: String?
	var description: String?
	var thumbnails: Thumbnails?
	var channelTitle: String?
	var playlistId: String?
	var position: Int?
	var resourceId: ResourceId?
	var liveBroadcastContent: String?
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

struct Details: Codable {
    var videoId: String?
    var videoPublishedAt: String?
	var duration: String?
	var dimension: String?
	var definition: String?
	var caption: String?
	var licensedContent: Bool?
	var projection: String?
}

struct JSONVideo {
	var title: String = ""
	var videoId: String = ""
	var pubDate: String = ""
	var artworkURL: String = ""
	var views: String = ""
	var likes: String = ""
	var duration: String = ""
}

// MARK: - Videos Methods -

extension API {

	func getVideos(using token: String, _ completion: ((YouTube<String>?) -> Void)?) {
		onVideoCompletion = completion

		let obfuscator = Obfuscator(with: APIParams.salt)
		let playlistId = obfuscator.reveal(key: APIParams.playlistId)
		let key = obfuscator.reveal(key: APIParams.key)

		var pageToken = ""
		if !token.isEmpty {
			pageToken = "&\(APIParams.pageToken)\(token)"
		}

		let host = "\(APIParams.playlistItems)?\(APIParams.playlistPart)&\(APIParams.playlistIdParam)\(playlistId)&\(APIParams.keyParam)\(key)&\(APIParams.maxResults)\(pageToken)&\(APIParams.sort)"

		executeGetVideoContent(host)
	}

	func getVideosStatistics(_ videos: [String], _ completion: ((YouTube<String>?) -> Void)?) {
		onVideoCompletion = completion

		let obfuscator = Obfuscator(with: APIParams.salt)
		let key = obfuscator.reveal(key: APIParams.key)
		let host = "\(APIParams.statistics)?\(APIParams.statisticsPart)&\(APIParams.videoId)\(videos.joined(separator: ","))&\(APIParams.keyParam)\(key)"

		executeGetVideoContent(host)
	}

	func searchVideos(_ text: String, _ completion: ((YouTube<ResourceId>?) -> Void)?) {
		onVideoSearchCompletion = completion

		let obfuscator = Obfuscator(with: APIParams.salt)
		let key = obfuscator.reveal(key: APIParams.key)
		let channelId = obfuscator.reveal(key: APIParams.channelId)

		let host = "\(APIParams.videoSearch)?\(APIParams.videoSearchPart)&\(APIParams.keyParam)\(key)&\(APIParams.maxResults)&\(APIParams.channel)\(channelId)&\(APIParams.videoQuery)\(text)&\(APIParams.sort)"

		executeGetVideoContent(host, isSearch: true)
	}

	fileprivate func executeGetVideoContent(_ host: String, isSearch: Bool? = false) {
        Cookies().cleanCookies()

		guard let url = URL(string: "\(host)") else {
			return
		}

        Network.getVdeos(url: url) { (result: Result<Data, RestAPIError>) in
            switch result {
                case .failure(_):
                    if isSearch ?? false {
                        self.onVideoSearchCompletion?(nil)
                    } else {
                        self.onVideoCompletion?(nil)
                    }

                case .success(let response):
                    self.parse(response,
                               isSearch: isSearch,
                               onVideoCompletion: self.onVideoCompletion,
                               onVideoSearchCompletion: self.onVideoSearchCompletion)
            }
		}
	}

}

extension API {
	func parse(_ data: Data, isSearch: Bool?, onVideoCompletion: ((YouTube<String>?) -> Void)?, onVideoSearchCompletion: ((YouTube<ResourceId>?) -> Void)?) {
		do {
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			decoder.dateDecodingStrategy = .iso8601

			if isSearch ?? false {
				let response = try decoder.decode(YouTube<ResourceId>.self, from: data)
				onVideoSearchCompletion?(response)
			} else {
				let response = try decoder.decode(YouTube<String>.self, from: data)
				onVideoCompletion?(response)
			}

		} catch {
			if isSearch ?? false {
				onVideoSearchCompletion?(nil)
			} else {
				onVideoCompletion?(nil)
			}
		}
	}
}

#endif
