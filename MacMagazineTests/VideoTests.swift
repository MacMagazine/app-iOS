//
//  VideoTests.swift
//  MacMagazineTests
//
//  Created by Cassio Rossi on 26/05/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import XCTest

class VideoTests: XCTestCase {

	let videoIds = ["Sx399pq69SA", "PJYAOYHC1Xw"]
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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

}
