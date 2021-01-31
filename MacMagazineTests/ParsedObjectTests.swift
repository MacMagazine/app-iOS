//
//  ParsedObjectTests.swift
//  MacMagazineTests
//
//  Created by Cassio Rossi on 26/05/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

@testable import MacMagazine
import XCTest

// Tests to be performed:
// 1) Create a mock test
// 2) Test for the content of the mock data, adding to the XMLPost class

class ParsedObjectTests: XCTestCase {

	var postExample: Data?
	let examplePost = ExamplePost()

	override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		guard let post = self.examplePost.getExamplePost() else {
			return
		}
		postExample = post
    }

	override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testGetPost() {
		XCTAssertNotNil(postExample, "Example post should exist")
	}

	func testParseExample() {
		guard let post = postExample else {
			XCTFail("Example post should exist")
			return
		}

		let expectation = self.expectation(description: "Testing API for a valid XML...")
		expectation.expectedFulfillmentCount = 2

		let onCompletion = { (post: XMLPost?) in
			guard let post = post else {
				expectation.fulfill()
				return
			}

			XCTAssertEqual(post.title, self.examplePost.getValidTitle(), "API response title must match")
			XCTAssertEqual(post.link, self.examplePost.getValidLink(), "API response link must match")
			XCTAssertEqual(post.pubDate, self.examplePost.getValidPubdate(), "API response date should must match")
			XCTAssertEqual(post.artworkURL, self.examplePost.getValidArtworkURL(), "API response artworkURL must match")
			XCTAssertEqual(post.podcastURL, "", "API response podcastURL must match")
			XCTAssertEqual(post.podcast, "", "API response podcast must match")
			XCTAssertEqual(post.duration, "", "API response duration must match")
			XCTAssertEqual(post.podcastFrame, "", "API response podcastFrame must match")
			XCTAssertEqual(post.excerpt, self.examplePost.getValidExcerpt(), "API response excerpt must match")
			XCTAssertEqual(post.categories, self.examplePost.getValidCategories(), "API response categories must match")

			expectation.fulfill()
		}

		API().parse(post, onCompletion: onCompletion, numberOfPosts: 1)

		waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}
}
