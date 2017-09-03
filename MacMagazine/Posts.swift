//
//  Posts.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 20/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import Foundation

class Post: NSObject {
	
	// MARK: - Properties
	
	public var id: Int
	public var post_date: Date
	public var title: String
	public var content: String
	
	// MARK: - Insert Object
	
	init(id: Int, post_date: Date, title: String, content: String) {
		self.id = id
		self.post_date = post_date
		self.title = title
		self.content = content
	}
}

func ==(lhs: Post, rhs: Post) -> Bool {
	return lhs.id == rhs.id && lhs.post_date == rhs.post_date && lhs.title == rhs.title && lhs.content == rhs.content
}

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
		let dateDescriptor = NSSortDescriptor(key: "post_date", ascending: true)
		
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
