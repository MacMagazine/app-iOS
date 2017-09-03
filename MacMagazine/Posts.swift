//
//  Posts.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 20/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import Foundation

class Post: NSObject {
	
	// MARK: - Properties -
	
	public var id: Int
	public var title: String
	public var content: String
	
	private var postDisplayDate: String?
	public var postDate = String() {
		didSet {
			if let posted_date = wordPressDateFormatter.date(from: postDate) {
				self.postDisplayDate = displayDateFormatter.string(from: posted_date)
			}
		}
	}

	// MARK: -  Local Methods -
	
	private let wordPressDateFormatter: DateFormatter = {
		// Expected date format: "2016-01-29T01:45:33"
		let formatter = DateFormatter()
		formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss"
		return formatter
	}()

	private let displayDateFormatter: DateFormatter = {
		// Expected date format: "2016-01-29T01:45:33"
		let formatter = DateFormatter()
		formatter.dateFormat = "DD/MM/YYYY"
		return formatter
	}()

	// MARK: - Insert Object -
	
	init(id: Int, postDate: String, title: String, content: String) {
		self.id = id
		self.title = title
		self.content = content

		super.init()

		({ self.postDate = postDate })()
	}

	// MARK: - Get Display Date -
	
	public func getDisplayDate() -> String? {
		return self.postDisplayDate
	}

}

// MARK: -
// MARK: - Compare Method -

func ==(lhs: Post, rhs: Post) -> Bool {
	return lhs.id == rhs.id && lhs.postDate == rhs.postDate && lhs.title == rhs.title && lhs.content == rhs.content
}

// MARK: -
// MARK: - Class -

class Posts {
	
	// Stores all posts here
	private var posts = [Post]()
	
	func isEmpty() -> Bool {
		return (self.posts.count == 0)
	}
	
	func getNumberOfPosts() -> NSInteger {
		return self.posts.count
	}
	
	func insertOrUpdatePost(post: Post) -> Void {
		// Cannot duplicate Ids
		if let p = self.findPostById(id: post.id) {
			if let idx = self.getIndexPost(of: p) {
				self.posts[idx] = post
			}
		} else {
			self.posts.append(post)
		}
	}
	
	func findPostById(id: Int) -> Post? {
		let posts = self.posts.filter() { $0.id == id }
		return (posts.count > 0 ? posts[0] : nil)
	}

	func deletePost(post: Post) -> Void {
		self.posts = self.posts.filter() { $0 !== post }
	}
	
	func sortPost() {
		let dateDescriptor = NSSortDescriptor(key: "postDate", ascending: true)
		
		self.posts = (self.posts as NSArray).sortedArray(using: [dateDescriptor]) as! [Post]
	}
	
	func getPostAtIndex(index: NSInteger) -> Post? {
		if self.getNumberOfPosts() > index {
			return self.posts[index]
		} else {
			return nil
		}
	}
	
	func getIndexPost(of: Post) -> Int? {
		return self.posts.index(of: of)
	}
	
}
