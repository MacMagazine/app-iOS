
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
	public var excerpt: String
	public var artwork: Int
	public var categorias: [Int]

	public var artworkURL: String?
	
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
	
	init(id: Int, postDate: String, title: String, content: String, excerpt: String, artwork: Int, categorias: [Int]) {
		self.id = id
		self.title = title
		self.content = content
		self.excerpt = excerpt
		self.artwork = artwork
		self.categorias = categorias
		
		super.init()
		
		({ self.postDate = postDate })()
	}
	
	// MARK: - Post Methods -
	
	public func getDisplayDate() -> String? {
		return self.postDisplayDate
	}
	
	public func hasCategory(id: Int) -> Bool {
		return self.categorias.contains(id)
	}

}

// MARK: -
// MARK: - Compare Method -

func ==(lhs: Post, rhs: Post) -> Bool {
	return lhs.id == rhs.id && lhs.postDate == rhs.postDate && lhs.title == rhs.title && lhs.content == rhs.content && lhs.excerpt == rhs.excerpt && lhs.artwork == rhs.artwork
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

	func filterByCategory(categoryId: Int) -> [Post]? {
		let posts = self.posts.filter() { $0.categorias.contains(categoryId) }
		return posts
	}

}

// MARK: -
// MARK: - Class Extension -

extension Network {
	public class func processJSON(json: [Dictionary<String, Any>]) -> Posts? {
		let posts = Posts()		// Stores all medias to display
		
		for data in json {
			// Get only the data we want
			
			guard
				let identifier = data["id"] as? Int,
				let dateString = data["date"] as? String,
				let artwork = data["featured_media"] as? Int,
				
				let titleDictionary = data["title"] as? Dictionary<String, Any>,
				let title = titleDictionary["rendered"] as? String,
				
				let contentDictionary = data["content"] as? Dictionary<String, Any>,
				let content = contentDictionary["rendered"] as? String,
				
				let excerptDictionary = data["excerpt"] as? Dictionary<String, Any>,
				let excerptHTML = excerptDictionary["rendered"] as? String,
			
				let categorias = data["categories"] as? [Int]
				
				else {
					return nil
			}
			
			let excerpt = excerptHTML.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
			
			let post = Post(id: identifier, postDate: dateString, title: title, content: content, excerpt: excerpt, artwork: artwork, categorias: categorias)
			
			posts.insertOrUpdatePost(post: post)
		}
		
		return posts
	}

	public class func processImageJSON(json: Dictionary<String, Any>) -> String? {
		var imageURL: String?
		
		// Get only the data we want
		guard
			let source_url = json["source_url"] as? String
		
			else {
				return nil
		}
		
		imageURL = source_url
		
		return imageURL
	}
}

