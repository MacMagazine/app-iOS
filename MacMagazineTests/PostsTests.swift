//
//  PostsTests.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 19/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import XCTest

class PostTests: XCTestCase {
	
	var item: Post?
	var post_date: Date?

	override func setUp() {
		super.setUp()
		// Put setup codvarere. This method is called before the invocation of each test method in the class.
		self.post_date = Date()
		self.item = Post(id: 0, post_date: self.post_date!, title: "title", content: "content")
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testThatItemHasId() {
		XCTAssertEqual(self.item!.id, 0, "ID should always be present")
	}

	func testThatItemHasDate() {
		XCTAssertEqual(self.item!.post_date, self.post_date, "Date should always be present")
	}

	func testThatItemHasTitle() {
		XCTAssertEqual(self.item!.title, "title", "Title should always be present")
	}
	
	func testThatItemHasContent() {
		XCTAssertEqual(self.item!.content, "content", "Content should always be present")
	}

	func testItemCanBeAssignedId() {
		self.item!.id = 1
		XCTAssertEqual(self.item!.id, 1, "ID should always be present")
	}
	
	func testItemCanBeAssignedDate() {
		self.post_date = Date()
		self.item!.post_date = self.post_date!
		XCTAssertEqual(self.item!.post_date, self.post_date!, "Date should always be present")
	}
	
	func testItemCanBeAssignedTitle() {
		self.item!.title = "New title"
		XCTAssertEqual(self.item!.title, "New title", "Title should always be present")
	}

	func testItemCanBeAssignedContent() {
		self.item!.content = "New content"
		XCTAssertEqual(self.item!.content, "New content", "Content should always be present")
	}

}

class PostsTests: XCTestCase {
	
	var posts: Posts?
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
		self.posts = Posts()
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testIsEmpty() {
		XCTAssertTrue(self.posts!.isEmpty())
	}
	
	func testGetNumberofPosts() {
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 0)
	}
	
	func testInsertPost() {
		let p = Post(id: 0, post_date: Date(), title: "title", content: "content")
		self.posts?.insertOrUpdatePost(post: p)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)
	}
	
	func testDeletePost() {
		// Test for valid data
		let p = Post(id: 0, post_date: Date(), title: "title", content: "content")
		self.posts?.insertOrUpdatePost(post: p)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)
		
		self.posts?.deletePost(post: p)
		
		XCTAssertTrue(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 0)
		
		// Test for wrong data
		self.posts?.insertOrUpdatePost(post: p)
		
		let p1 = Post(id: 1, post_date: Date(), title: "title1", content: "content1")
		self.posts?.deletePost(post: p1)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)
	}
	
	func testGetPostAtIndex() {
		// Test for valid data
		let p = Post(id: 0, post_date: Date(), title: "title", content: "content")
		self.posts?.insertOrUpdatePost(post: p)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)

		if let postToCompare = self.posts?.getPostAtIndex(index: 0) {
			XCTAssertTrue(postToCompare == p)
		} else {
			XCTFail("Object is Nil")
		}
		
		// Test for wrong data
		XCTAssertNil(self.posts?.getPostAtIndex(index: 1))
	}

	func testFindPostById() {
		let p = Post(id: 0, post_date: Date(), title: "title", content: "content")
		self.posts?.insertOrUpdatePost(post: p)

		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)

		if let postToCompare = self.posts?.findPostById(id: 0) {
			XCTAssertTrue(postToCompare == p)
		} else {
			XCTFail("Object is Nil")
		}

		// Test for wrong data
		XCTAssertNil(self.posts?.findPostById(id: 1))
	}

	func testGetIndexPost() {
		let p = Post(id: 0, post_date: Date(), title: "title", content: "content")
		self.posts?.insertOrUpdatePost(post: p)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)

		XCTAssertEqual(self.posts?.getIndexPost(of: p), 0)
	}

	func testUniqueId() {
		let p = Post(id: 0, post_date: Date(), title: "title", content: "content")
		self.posts?.insertOrUpdatePost(post: p)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)

		let p1 = Post(id: 0, post_date: Date(), title: "title1", content: "content1")
		self.posts?.insertOrUpdatePost(post: p1)

		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)
		
		if let postToCompare = self.posts?.getPostAtIndex(index: 0) {
			XCTAssertTrue(postToCompare == p1)
		} else {
			XCTFail("Object is Nil")
		}

	}
}
