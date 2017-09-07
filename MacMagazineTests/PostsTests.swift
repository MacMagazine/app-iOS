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
	var postDate: String?

	override func setUp() {
		super.setUp()
		// Put setup codvarere. This method is called before the invocation of each test method in the class.
		self.postDate = "2001-01-01T01:01:01"
		self.item = Post(id: 0, postDate: self.postDate!, title: "title", content: "content", excerpt: "excerpt", artwork: 1234, categorias: [10])
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testThatItemHasId() {
		XCTAssertEqual(self.item!.id, 0, "ID should always be present")
	}

	func testThatItemHasDate() {
		XCTAssertEqual(self.item!.postDate, self.postDate, "Date should always be present")
	}

	func testThatItemHasTitle() {
		XCTAssertEqual(self.item!.title, "title", "Title should always be present")
	}
	
	func testThatItemHasContent() {
		XCTAssertEqual(self.item!.content, "content", "Content should always be present")
	}

	func testThatItemHasExcerpt() {
		XCTAssertEqual(self.item!.excerpt, "excerpt", "Excerpt should always be present")
	}

    func testThatItemHasArtwork() {
        XCTAssertEqual(self.item!.artwork, 1234, "Artwork should always be present")
    }

	func testThatItemHasCategories() {
		XCTAssertEqual(self.item!.categorias, [10], "Categories should always be present")
	}

	func testItemCanBeAssignedId() {
		self.item!.id = 1
		XCTAssertEqual(self.item!.id, 1, "ID should always be present")
	}
	
	func testItemCanBeAssignedDate() {
		self.postDate = "2001-01-02T01:01:01"
		self.item!.postDate = self.postDate!
		XCTAssertEqual(self.item!.postDate, self.postDate!, "Date should always be present")
	}

	func testItemHaveDisplayDate() {
		XCTAssertEqual(self.item!.getDisplayDate(), "01/01/2001", "Display Date should always be present")
	}

	func testItemCanChangeDisplayDate() {
		XCTAssertEqual(self.item!.getDisplayDate(), "01/01/2001", "Display Date should always be present")

		self.postDate = "2001-01-02T01:01:01"
		self.item!.postDate = self.postDate!

		XCTAssertEqual(self.item!.getDisplayDate(), "02/01/2001", "Display Date should always be present")
	}

	func testItemCanBeAssignedTitle() {
		self.item!.title = "New title"
		XCTAssertEqual(self.item!.title, "New title", "Title should always be present")
	}

	func testItemCanBeAssignedContent() {
		self.item!.content = "New content"
		XCTAssertEqual(self.item!.content, "New content", "Content should always be present")
	}

	func testItemCanBeAssignedExcerpt() {
		self.item!.excerpt = "New excerpt"
		XCTAssertEqual(self.item!.excerpt, "New excerpt", "Excerpt should always be present")
	}

    func testItemCanBeAssignedArwork() {
        self.item!.artwork = 4321
        XCTAssertEqual(self.item!.artwork, 4321, "Artwork should always be present")
    }

	func testItemCanBeAssignedCategories() {
		self.item!.categorias = [20]
		XCTAssertEqual(self.item!.categorias, [20], "Categories should always be present")
	}

	func testHasCategoryId() {
		XCTAssertTrue(self.item!.hasCategory(id: 10), "Categories doesn't match")
		XCTAssertFalse(self.item!.hasCategory(id: 20), "Categories match")
	}

}

class PostsTests: XCTestCase {
	
	var posts: Posts?
	var p: Post?

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
		self.posts = Posts()
		self.p = Post(id: 0, postDate: "2007-01-01T01:01:01", title: "title", content: "content", excerpt: "excerpt1", artwork: 1234, categorias: [10])
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
		XCTAssertTrue(self.posts!.isEmpty())

		self.posts?.insertOrUpdatePost(post: self.p!)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)

		let p1 = Post(id: 10, postDate: "2007-01-01T01:01:01", title: "title1", content: "content1", excerpt: "excerpt1", artwork: 4321, categorias: [20])
		self.posts?.insertOrUpdatePost(post: p1)

		XCTAssertEqual(self.posts?.getNumberOfPosts(), 2)
	}
	
	func testDeletePost() {
		// Test for valid data
		self.posts?.insertOrUpdatePost(post: self.p!)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)
		
		self.posts?.deletePost(post: self.p!)
		
		XCTAssertTrue(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 0)
		
		// Test for wrong data
		self.posts?.insertOrUpdatePost(post: self.p!)
		
        let p1 = Post(id: 1, postDate: "2007-01-01T01:01:01", title: "title1", content: "content1", excerpt: "excerpt1", artwork: 4321, categorias: [20])
		self.posts?.deletePost(post: p1)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)
	}
	
	func testGetPostAtIndex() {
		// Test for valid data
		self.posts?.insertOrUpdatePost(post: self.p!)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)

		if let postToCompare = self.posts?.getPostAtIndex(index: 0) {
			XCTAssertTrue(postToCompare == self.p!)
		} else {
			XCTFail("Object is Nil")
		}
		
		// Test for wrong data
		XCTAssertNil(self.posts?.getPostAtIndex(index: 1))
	}

	func testFindPostById() {
		self.posts?.insertOrUpdatePost(post: self.p!)

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
		self.posts?.insertOrUpdatePost(post: self.p!)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)

		XCTAssertEqual(self.posts?.getIndexPost(of: self.p!), 0)
	}

	func testUniqueId() {
		self.posts?.insertOrUpdatePost(post: self.p!)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)

		let p1 = Post(id: 0, postDate: "2001-01-02T01:01:01", title: "title1", content: "content1", excerpt: "excerpt1", artwork: 4321, categorias: [20])
		self.posts?.insertOrUpdatePost(post: p1)

		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)
		
		if let postToCompare = self.posts?.getPostAtIndex(index: 0) {
			XCTAssertTrue(postToCompare == p1)
		} else {
			XCTFail("Object is Nil")
		}

	}

	func testGetNumberOfFilteredPosts() {
		self.posts?.insertOrUpdatePost(post: self.p!)

		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)
		
		let p1 = Post(id: 1, postDate: "2001-01-02T01:01:01", title: "title1", content: "content1", excerpt: "excerpt1", artwork: 4321, categorias: [20, 30])
		self.posts?.insertOrUpdatePost(post: p1)
		
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 2)
		XCTAssertEqual(self.posts?.getNumberOfPosts(inCategory: 10), 1)

		let p2 = Post(id: 2, postDate: "2001-01-02T01:01:01", title: "title1", content: "content1", excerpt: "excerpt1", artwork: 4321, categorias: [10, 20, 30])
		self.posts?.insertOrUpdatePost(post: p2)
		
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 3)
		XCTAssertEqual(self.posts?.getNumberOfPosts(inCategory: 10), 2)
		XCTAssertEqual(self.posts?.getNumberOfPosts(inCategory: 20), 2)
	}

	func testFilterByCategory() {
		self.posts?.insertOrUpdatePost(post: self.p!)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)

		let p1 = Post(id: 1, postDate: "2001-01-02T01:01:01", title: "title1", content: "content1", excerpt: "excerpt1", artwork: 4321, categorias: [10, 20, 30])
		self.posts?.insertOrUpdatePost(post: p1)

		XCTAssertEqual(self.posts?.getNumberOfPosts(), 2)

		if let postsToCompare = self.posts?.filterByCategory(categoryId: 10) {
			let filteredPost = Posts()
			for post in postsToCompare {
				filteredPost.insertOrUpdatePost(post: post)
			}
			XCTAssertEqual(filteredPost.getNumberOfPosts(), 2)
		} else {
			XCTFail("Object is Nil")
		}

		if let postsToCompare = self.posts?.filterByCategory(categoryId: 20) {
			let filteredPost = Posts()
			for post in postsToCompare {
				filteredPost.insertOrUpdatePost(post: post)
			}
			XCTAssertEqual(filteredPost.getNumberOfPosts(), 1)
		} else {
			XCTFail("Object is Nil")
		}
	}

	func testGetNumberOfFilteredExcludedPosts() {
		self.posts?.insertOrUpdatePost(post: self.p!)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)
		
		let p1 = Post(id: 1, postDate: "2001-01-02T01:01:01", title: "title1", content: "content1", excerpt: "excerpt1", artwork: 4321, categorias: [20, 30])
		self.posts?.insertOrUpdatePost(post: p1)
		
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 2)
		XCTAssertEqual(self.posts?.getNumberOfPosts(notInCategory: 10), 1)
		
		let p2 = Post(id: 2, postDate: "2001-01-02T01:01:01", title: "title1", content: "content1", excerpt: "excerpt1", artwork: 4321, categorias: [10, 20, 30])
		self.posts?.insertOrUpdatePost(post: p2)
		
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 3)
		XCTAssertEqual(self.posts?.getNumberOfPosts(notInCategory: 10), 1)
		XCTAssertEqual(self.posts?.getNumberOfPosts(notInCategory: 20), 1)
	}
	
	func testFilterExcludedCategory() {
		self.posts?.insertOrUpdatePost(post: self.p!)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)
		
		let p1 = Post(id: 1, postDate: "2001-01-02T01:01:01", title: "title1", content: "content1", excerpt: "excerpt1", artwork: 4321, categorias: [20, 30])
		self.posts?.insertOrUpdatePost(post: p1)
		
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 2)
		
		if let postsToCompare = self.posts?.filterExcludingCategory(categoryId: 10) {
			let filteredPost = Posts()
			for post in postsToCompare {
				filteredPost.insertOrUpdatePost(post: post)
			}
			XCTAssertEqual(filteredPost.getNumberOfPosts(), 1)
		} else {
			XCTFail("Object is Nil")
		}
		
		if let postsToCompare = self.posts?.filterExcludingCategory(categoryId: 20) {
			let filteredPost = Posts()
			for post in postsToCompare {
				filteredPost.insertOrUpdatePost(post: post)
			}
			XCTAssertEqual(filteredPost.getNumberOfPosts(), 1)
		} else {
			XCTFail("Object is Nil")
		}
	}

	func testExcludePost() {
		self.posts?.insertOrUpdatePost(post: self.p!)
		
		XCTAssertFalse(self.posts!.isEmpty())
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)
		
		let p1 = Post(id: 1, postDate: "2001-01-02T01:01:01", title: "title1", content: "content1", excerpt: "excerpt1", artwork: 4321, categorias: [20, 30])
		self.posts?.insertOrUpdatePost(post: p1)
		
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 2)
		
		self.posts?.excludePost(fromCategoryId: 10)
		XCTAssertEqual(self.posts?.getNumberOfPosts(), 1)
	}
	
}
