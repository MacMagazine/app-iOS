//
//  VideoTests.swift
//  MacMagazineTests
//
//  Created by Cassio Rossi on 26/05/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

@testable import MacMagazine
import XCTest

class VideoTests: XCTestCase {

	let videoIds = ["Sx399pq69SA", "PJYAOYHC1Xw"]
	var videoExample: Data?
	var videoStatsExample: Data?
	let exampleVideo = ExampleVideo()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		guard let video = self.exampleVideo.getExampleVideo(),
			let stats = self.exampleVideo.getExampleStats()
			else {
				return
		}
		videoExample = video
		videoStatsExample = stats
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testAPIReturnAnyData() {
		let expectation = self.expectation(description: "Testing API for any Data...")
		expectation.expectedFulfillmentCount = 1

		API().getVideos(using: "") { videos in
			guard let rsp = videos,
				let items = rsp.items
				else {
					XCTAssertNil(videos, "API response must not be nil")
					return
			}
			XCTAssertEqual(items.count, 15, "Items should be equal to 15")
			expectation.fulfill()
		}

		waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}

    func testAPIReturnValidData() {
		let expectation = self.expectation(description: "Testing API for a valid Data...")
		expectation.expectedFulfillmentCount = 1

		API().getVideos(using: "") { videos in
			guard let rsp = videos,
				let items = rsp.items
				else {
					XCTAssertNil(videos, "API response must not be nil")
					return
			}
			XCTAssertEqual(items.count, 15, "Items should be equal to 15")

			let video = items[0]
			XCTAssertNotEqual(video.id, "", "API response id must match")
			XCTAssertNotEqual(video.snippet?.channelId, "", "API response channelId must match")
			XCTAssertNotEqual(video.snippet?.title, "", "API response title must match")

			expectation.fulfill()
		}

		waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}

	func testAPIReturnStatsAnyData() {
		let expectation = self.expectation(description: "Testing API for any Data...")
		expectation.expectedFulfillmentCount = 1

		API().getVideosStatistics(videoIds) { statistics in
			guard let stats = statistics?.items else {
				XCTAssertNil(statistics?.items, "API response must not be nil")
				return
			}
			XCTAssertEqual(stats.count, 2, "Items should be equal to 2")
			expectation.fulfill()
		}

        waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}

	func testAPIReturnStatsValidData() {
		let expectation = self.expectation(description: "Testing API for a valid Data...")
		expectation.expectedFulfillmentCount = 1

		API().getVideosStatistics(videoIds) { statistics in
			guard let stats = statistics?.items else {
				XCTAssertNil(statistics?.items, "API response must not be nil")
				return
			}

			XCTAssertEqual(stats[0].kind, "youtube#video", "API response kind must match")
			XCTAssertEqual(stats[0].id, "Sx399pq69SA", "API response id must match")

			XCTAssertEqual(stats[1].kind, "youtube#video", "API response kind must match")
			XCTAssertEqual(stats[1].id, "PJYAOYHC1Xw", "API response id must match")

			expectation.fulfill()
		}

		waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}

	func testVideoAPI() {
		let expectation = self.expectation(description: "Testing API for a valid Data...")
		expectation.expectedFulfillmentCount = 1

        API().getVideosStatistics(videoIds) { statistics in
			guard let stats = statistics?.items else {
				XCTAssertNil(statistics?.items, "API response must not be nil")
				return
			}

            XCTAssertEqual(stats[0].kind, "youtube#video", "API response kind must match")
			XCTAssertEqual(stats[0].id, "Sx399pq69SA", "API response id must match")

            XCTAssertEqual(stats[1].kind, "youtube#video", "API response kind must match")
			XCTAssertEqual(stats[1].id, "PJYAOYHC1Xw", "API response id must match")

            expectation.fulfill()
		}

        waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}

	func testGetVideo() {
		XCTAssertNotNil(videoExample, "Example post should exist")
	}

    func testParseExampleVideo() {
		guard let video = videoExample,
			let stats = videoStatsExample
			else {
				XCTFail("Example video should exist")
				return
		}

		let onVideoCompletion = { (videos: YouTube<String>?) in
			guard let parsedVideo = videos else {
				XCTFail("parsedVideo should exist")
				return
			}
			XCTAssertEqual(parsedVideo.kind, self.exampleVideo.getExampleKind(), "API response kind must match")
			XCTAssertEqual(parsedVideo.nextPageToken, self.exampleVideo.getExampleNextPageToken(), "API response nextPageToken must match")

            XCTAssertNotNil(parsedVideo.pageInfo, "pageInfo should not be nil")
			XCTAssertEqual(parsedVideo.pageInfo?.totalResults, self.exampleVideo.getExamplePageInfoTotalResults(), "API response pageInfo.totalResults must match")

            XCTAssertNotNil(parsedVideo.items, "items should not be nil")
			XCTAssertEqual(parsedVideo.items?.count, 1, "There should be only 1 item")
			if !(parsedVideo.items?.isEmpty ?? true) {
				XCTAssertEqual(parsedVideo.items?[0].id, self.exampleVideo.getExampleItemsId(), "API response items.id must match")
			}
		}
		API().parse(video, isSearch: nil, onVideoCompletion: onVideoCompletion, onVideoSearchCompletion: nil)

		let onVideoStatsCompletion = { (videos: YouTube<String>?) in
			guard let parsedVideoStats = videos else {
				XCTFail("parsedVideoStats should exist")
				return
			}
			XCTAssertEqual(parsedVideoStats.kind, self.exampleVideo.getExampleStatKind(), "API response kind must match")

            XCTAssertNotNil(parsedVideoStats.pageInfo, "pageInfo should not be nil")
			XCTAssertEqual(parsedVideoStats.pageInfo?.totalResults, self.exampleVideo.getExampleStatsPageInfoTotalResults(), "API response pageInfo.totalResults must match")

            XCTAssertNotNil(parsedVideoStats.items, "items should not be nil")
			XCTAssertEqual(parsedVideoStats.items?.count, 1, "There should be only 1 item")
			if !(parsedVideoStats.items?.isEmpty ?? true) {
				XCTAssertEqual(parsedVideoStats.items?[0].id, self.exampleVideo.getExampleStatsItemsId(), "API response items.id must match")

                XCTAssertNotNil(parsedVideoStats.items?[0].statistics, "items should not be nil")
				XCTAssertEqual(parsedVideoStats.items?[0].statistics?.viewCount, self.exampleVideo.getExampleStatsStatisticsViewCount(), "API response items.statistics.viewCount must match")
				XCTAssertEqual(parsedVideoStats.items?[0].statistics?.likeCount, self.exampleVideo.getExampleStatsStatisticsLikeCount(), "API response items.statistics.likeCount must match")
			}
		}
		API().parse(stats, isSearch: nil, onVideoCompletion: onVideoStatsCompletion, onVideoSearchCompletion: nil)
	}

	func testSaveParsedExampleVideo() {
		let expectation = self.expectation(description: "Testing API for a valid Data...")
		expectation.expectedFulfillmentCount = 1

		saveVideo { video in
			XCTAssertEqual(video.count, 1, "Response should be 1")
			if !video.isEmpty {
				XCTAssertEqual(video[0].videoId, self.exampleVideo.getExampleVideoId(), "videoId must match")
			}

            expectation.fulfill()
		}

		waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}

	func testFavoriteVideo() {
		let expectation = self.expectation(description: "Testing API for a valid data on database...")
		expectation.expectedFulfillmentCount = 1

		saveVideo { video in
			if video.isEmpty {
				XCTFail("Database is empty")
			} else {
				XCTAssertEqual(video.count, 1, "Should retrieve only 1 video")

				XCTAssertEqual(video[0].favorite, false, "API response favorite must be false")

				Favorite().updateVideoStatus(using: self.exampleVideo.getExampleVideoId()) { isFavoriteOn in
					XCTAssertEqual(isFavoriteOn, true, "API response favorite must be true")

					Favorite().updateVideoStatus(using: self.exampleVideo.getExampleVideoId()) { isFavoriteOn in
						XCTAssertEqual(isFavoriteOn, false, "API response favorite must be false")
						expectation.fulfill()
					}
				}
			}
		}

		waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}

}

extension VideoTests {
	func saveVideo(_ onCompletion: @escaping (([Video]) -> Void)) {
		guard let video = videoExample,
			let stats = videoStatsExample
			else {
				XCTFail("Example video should exist")
				return
		}

        var parsedVideo: YouTube<String>?
		let onVideoCompletion = { (videos: YouTube<String>?) in
			parsedVideo = videos
		}
		let onVideoStatsCompletion = { (videos: YouTube<String>?) in
			guard let parsedVideo = parsedVideo,
				let parsedVideoStats = videos,
				let stats = parsedVideoStats.items
				else {
					XCTFail("parsedVideoStats should exist")
					return
			}

            CoreDataStack.shared.save(playlist: parsedVideo, statistics: stats)
			delay(0.4) {
				CoreDataStack.shared.get(video: self.exampleVideo.getExampleVideoId()) { video in
					onCompletion(video)
				}
			}
		}
		API().parse(video, isSearch: nil, onVideoCompletion: onVideoCompletion, onVideoSearchCompletion: nil)
		API().parse(stats, isSearch: nil, onVideoCompletion: onVideoStatsCompletion, onVideoSearchCompletion: nil)
	}
}
