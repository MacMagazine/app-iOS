//
//  PostsTests.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 19/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

@testable import MacMagazine
import XCTest

// Tests to be performed:
// 1) Create a mock test
// 2) Test for the content of the mock data, adding to the XMLPost class
// 3) Save mock data to database
// 4) Validate content of the database

class PostTests: XCTestCase {

    var postExample: Data? = ExamplePost().getExamplePost()
	let examplePost = ExamplePost()

	override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testGetPost() {
		XCTAssertNotNil(postExample, "Example post should exist")
	}

    func testParseAndSaveExample() {
		let expectation = self.expectation(description: "Testing API for a valid data on database...")
		expectation.expectedFulfillmentCount = 1

		savePost { posts in
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

		waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}

	func testFavoritePost() {
		let expectation = self.expectation(description: "Testing API for a valid data on database...")
		expectation.expectedFulfillmentCount = 1

		savePost { posts in
			if posts.isEmpty {
				XCTFail("Database is empty")
                expectation.fulfill()
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

	func testPostDestaque() {
		let expectation = self.expectation(description: "Testing API for a valid data on database...")
		expectation.expectedFulfillmentCount = 1

        savePost { posts in
            XCTAssertEqual(posts.count, 1)
            XCTAssertEqual(posts[0].categorias?.contains("Destaques"), false, "Post shouldn't be 'Destaque'")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}

	func testPreventDuplicates() {
		let expectation = self.expectation(description: "Testing database to prevent duplicates...")
		expectation.expectedFulfillmentCount = 1

		guard let data = self.examplePost.getExamplePosts() else {
			XCTFail("Example posts should exist")
			return
		}

		var posts: [XMLPost] = []
		let completion = { (post: XMLPost?) in
			guard let post = post else {
				XCTAssertEqual(posts.count, 2, "Should have 2 posts")

				delay(0.1) {
                    CoreDataStack.shared.get(link: self.examplePost.getValidLink()) { (db: [Post]) in
						XCTAssertEqual(db.count, 1, "Should retrieve only 1 post")
						expectation.fulfill()
					}
				}
				return
			}
			posts.append(post)
			CoreDataStack.shared.save(post: post)
		}
		API().parse(data, onCompletion: completion, numberOfPosts: 2)

		waitForExpectations(timeout: 30) { error in
			XCTAssertNil(error, "Error occurred: \(String(describing: error))")
		}
	}

    func testDeleteFromDB() {
        let expectation = self.expectation(description: "Testing delete post from database...")
        expectation.expectedFulfillmentCount = 1

        CoreDataStack.shared.flush(type: .all)

        // 1. Make sure there is no saved posts
        self.getAllPosts(count: 0) {
            // 2. Parse and save posts
            self.load(data: MockPosts().posts, count: 20) { _ in
                // 3. Make sure the number of saved posts matches
                self.getAllPosts(count: 20) {
                    // 4. Load new set of posts
                    self.load(data: MockPosts2().posts, count: 18) { posts in
                        // 5. Make sure the number of saved posts still matches
                        self.getAllPosts(count: 20) {
                            // 6. There are two posts to delete
                            CoreDataStack.shared.delete(posts.map { $0.postId }, page: 0)

                            // 7. Make sure the number of saved posts still matches
                            self.getAllPosts(count: 18) {
                                expectation.fulfill()
                            }
                        }
                    }
                }
            }
        }

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Error occurred: \(String(describing: error))")
        }
    }

    func testNothingToDeleteFromDB() {
        let expectation = self.expectation(description: "Testing nothing to delete post from database...")
        expectation.expectedFulfillmentCount = 1

        CoreDataStack.shared.flush(type: .all)

        // 1. Make sure there is no saved posts
        self.getAllPosts(count: 0) {
            // 2. Parse and save posts
            self.load(data: MockPosts2().posts, count: 18) { _ in
                // 3. Make sure the number of saved posts matches
                self.getAllPosts(count: 18) {
                    // 4. Load new set of posts
                    self.load(data: MockPosts().posts, count: 20) { posts in
                        // 5. Make sure the number of saved posts still matches
                        self.getAllPosts(count: 20) {
                            // 6. There are two posts to delete
                            CoreDataStack.shared.delete(posts.map { $0.postId }, page: 0)

                            // 7. Make sure the number of saved posts still matches
                            self.getAllPosts(count: 20) {
                                expectation.fulfill()
                            }
                        }
                    }
                }
            }
        }

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Error occurred: \(String(describing: error))")
        }
    }
}

extension PostTests {
	func parseExample(_ onCompletion: @escaping ((XMLPost?) -> Void)) {
		guard let example = postExample else {
			XCTFail("Example post should exist")
			return
		}
		API().parse(example, onCompletion: { (post: XMLPost?) in
			onCompletion(post)
		}, numberOfPosts: -1)
	}

	func savePost(_ onCompletion: @escaping (([Post]) -> Void)) {
		parseExample { post in
			guard let post = post else {
				delay(0.4) {
					CoreDataStack.shared.get(link: self.examplePost.getValidLink()) { posts in
						onCompletion(posts)
					}
				}
				return
			}
			CoreDataStack.shared.save(post: post)
		}
	}
}

extension PostTests {
    func getAllPosts(count: Int, onCompletion: (() -> Void)?) {
        delay(0.2) {
            CoreDataStack.shared.getAll { posts in
                XCTAssertEqual(posts.count, count)
                onCompletion?()
            }
        }
    }

    func load(data: Data?, count: Int, onCompletion: (([XMLPost]) -> Void)?) {
        guard let data = data else {
            XCTFail("Example posts should exist")
            return
        }

        var posts: [XMLPost] = []
        let completion = { (post: XMLPost?) in
            guard let post = post else {
                XCTAssertEqual(posts.count, count)
                onCompletion?(posts)
                return
            }
            posts.append(post)
            CoreDataStack.shared.save(post: post)
        }
        API().parse(data, onCompletion: completion, numberOfPosts: -1)
    }
}
