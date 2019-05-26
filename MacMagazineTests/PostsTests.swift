//
//  PostsTests.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 19/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import XCTest
@testable import MacMagazine

// Tests to be performed:
// 1) Create a mock test
// 2) Test for the content of the mock data, adding to the XMLPost class
// 3) Save mock data to database
// 4) Validate content of the database

class PostTests: XCTestCase {

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
		super.tearDown()
	}

	func testGetPost() {
		XCTAssertNotNil(postExample, "Example post should exist")
	}
	
	func testParseAndSaveExample() {
		guard let post = postExample else {
			XCTFail("Example post should exist")
			return
		}
		
		let expectation = self.expectation(description: "Testing API for a valid data on database...")
		expectation.expectedFulfillmentCount = 2
		
		let onCompletion = { (post: XMLPost?) in
			guard let post = post else {
				CoreDataStack.shared.get(post: self.examplePost.getValidLink()) { posts in

					if posts.isEmpty {
						XCTFail("Database is empty")
					} else {
						XCTAssertEqual(posts.count, 1, "Should retrieve only 1 post")

						XCTAssertEqual(posts[0].title, self.examplePost.getValidTitle(), "API response title must match")
						XCTAssertEqual(posts[0].link, self.examplePost.getValidLink(), "API response link must match")
						XCTAssertEqual(posts[0].pubDate, self.examplePost.getValidDBPubdate(), "API response date should must match")
						XCTAssertEqual(posts[0].artworkURL, self.examplePost.getValidArtworkURL(), "API response artworkURL must match")
						XCTAssertEqual(posts[0].podcastURL, "", "API response podcastURL must match")
						XCTAssertEqual(posts[0].podcast, "", "API response podcast must match")
						XCTAssertEqual(posts[0].duration, "", "API response duration must match")
						XCTAssertEqual(posts[0].podcastFrame, "", "API response podcastFrame must match")
						XCTAssertEqual(posts[0].excerpt, self.examplePost.getValidDBExcerpt(), "API response excerpt must match")
						XCTAssertEqual(posts[0].categorias, self.examplePost.getValidDBCategories(), "API response categories must match")
					}

					expectation.fulfill()
				}
				return
			}

			CoreDataStack.shared.save(post: post)
			expectation.fulfill()
		}

		API().parse(post, onCompletion: onCompletion, isComplication: false)

		waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}

	func testFavoritePost() {
		let expectation = self.expectation(description: "Testing API for a valid data on database...")
		expectation.expectedFulfillmentCount = 1

		CoreDataStack.shared.get(post: self.examplePost.getValidLink()) { posts in
			if posts.isEmpty {
				XCTFail("Database is empty")
			} else {
				XCTAssertEqual(posts.count, 1, "Should retrieve only 1 post")
				
				XCTAssertEqual(posts[0].favorite, false, "API response favorite must be false")

				Favorite().updatePostStatus(using: self.examplePost.getValidLink()) { isFavoriteOn in
					XCTAssertEqual(isFavoriteOn, true, "API response favorite must be true")

					Favorite().updatePostStatus(using: self.examplePost.getValidLink()) { isFavoriteOn in
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
