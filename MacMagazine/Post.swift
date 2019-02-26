//
//  Post.swift
//
//  Created by Cassio Rossi on 22/09/16.
//  Copyright © 2016 Cassio Rossi. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import CoreData
import UIKit

// MARK: -
// MARK: - Post Object -

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

	// MARK: - Local Methods -

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

	private func decodeHTMLString(string: String) -> String? {

		guard let encodedData = string.data(using: String.Encoding.utf8) else {
			return nil
		}
		do {
			return try NSAttributedString(data: encodedData, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string
		} catch {
			print("error: ", error)
			return nil
		}

	}

	init(id: Int, postDate: String, title: String, content: String, excerpt: String, artwork: Int, categorias: [Int], artworkURL: String?) {
		self.id = id
		self.title = title
		self.content = content
		self.excerpt = excerpt
		self.artwork = artwork
		self.artworkURL = artworkURL
		self.categorias = categorias

		super.init()

		({ self.postDate = postDate })()
		self.excerpt = self.decodeHTMLString(string: excerpt)!
		self.title = self.decodeHTMLString(string: title)!
	}

	// MARK: - Post Methods -

	public func getDisplayDate() -> String? {
		return self.postDisplayDate
	}

	public func hasCategory(id: Int) -> Bool {
		return self.categorias.contains(id)
	}

	public func getCategorias() -> String {
		return (self.categorias.map { String($0) }).joined(separator: ",")
	}

}

// MARK: -
// MARK: - Post Compare Method -

func ==(lhs: Post, rhs: Post) -> Bool {
	return lhs.id == rhs.id && lhs.postDate == rhs.postDate && lhs.title == rhs.title && lhs.content == rhs.content && lhs.excerpt == rhs.excerpt && lhs.artwork == rhs.artwork
}

// MARK: -
// MARK: - Core Data Methods -

@objc(Posts)
public class Posts: NSManagedObject {

	class func getPosts() -> [Posts] {
		return self.getPosts(byId: nil, inCategory: nil, notInCategory: nil)
	}

	class func getPost(byId: Int) -> Posts? {
		let posts = self.getPosts(byId: byId, inCategory: nil, notInCategory: nil)
		return (posts.count == 1 ? posts[0] : nil)
	}

	class func getPost(atIndex: Int) -> Posts? {
		let posts = self.getPosts(byId: nil, inCategory: nil, notInCategory: nil)
		return (posts.isEmpty ? posts[atIndex] : nil)
	}

	class func getPosts(inCategory: Int?) -> [Posts] {
		return self.getPosts(byId: nil, inCategory: inCategory, notInCategory: nil)
	}

	class func getPosts(notInCategory: Int?) -> [Posts] {
		return self.getPosts(byId: nil, inCategory: nil, notInCategory: notInCategory)
	}

	class func getPosts(byId: Int?, inCategory: Int?, notInCategory: Int?) -> [Posts] {
		var item = [Posts]()

		// Execute the fetch request
		let request: NSFetchRequest<Posts> = Posts.fetchRequest()
		if byId != nil {
			request.predicate = NSPredicate(format: "id == %@", NSNumber(value: byId!))
		}
		if inCategory != nil {
			request.predicate = NSPredicate(format: "categorias CONTAINS[cd] %@", String(inCategory!))
		}
		if notInCategory != nil {
			request.predicate = NSPredicate(format: "NOT categorias CONTAINS[cd] %@", String(notInCategory!))
		}

		do {
			let results = try self.privateManagedObjectContext().fetch(request)
			item = results

		} catch let error as NSError {
			print("\(error), \(error.userInfo)")
		}

		return item
	}

	class func isEmpty() -> Bool {
		let posts = self.getPosts()
		return (posts.isEmpty)
	}

	class func getNumberOfPosts() -> Int {
		let posts = self.getPosts()
		return posts.count
	}

	class func getNumberOfPosts(inCategory: Int?) -> Int {
		let posts = self.getPosts(inCategory: inCategory)
		return posts.count
	}

	class func getNumberOfPosts(notInCategory: Int) -> Int {
		let posts = self.getPosts(notInCategory: notInCategory)
		return posts.count
	}

	class func insertOrUpdatePost(post: Post) {
		// Cannot duplicate Ids
		if let item = self.getPost(byId: post.id) {
			item.title = post.title
			item.content = post.content
			item.excerpt = post.excerpt
			item.artwork = NSNumber(value: post.artwork)
			item.artworkURL = post.artworkURL
			item.categorias = post.getCategorias()
			item.postDisplayDate = post.getDisplayDate()
			item.postDate = post.postDate

		} else {

			let newItem = NSEntityDescription.insertNewObject(forEntityName: self.entityName(), into: self.privateManagedObjectContext()) as! Posts

			newItem.id = NSNumber(value: post.id)
			newItem.title = post.title
			newItem.content = post.content
			newItem.excerpt = post.excerpt
			newItem.artwork = NSNumber(value: post.artwork)
			newItem.artworkURL = post.artworkURL
			newItem.categorias = post.getCategorias()
			newItem.postDisplayDate = post.getDisplayDate()
			newItem.postDate = post.postDate
		}
	}

	class func deletePost(post: Posts) {
		self.managedObjectContext().delete(post)
		DataController.sharedInstance.saveContext()
	}

}

// MARK: -
// MARK: - Core Data Definitions -

extension Posts {

	public class func entityName() -> String {
		return "Post"
	}

	public class func privateManagedObjectContext() -> NSManagedObjectContext {
		return DataController.sharedInstance.privateManagedObjectContext
	}

	public class func managedObjectContext() -> NSManagedObjectContext {
		return DataController.sharedInstance.managedObjectContext
	}

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Posts> {
		return NSFetchRequest<Posts>(entityName: self.entityName())
	}

	@NSManaged public var id: NSNumber?
	@NSManaged public var title: String
	@NSManaged public var content: String
	@NSManaged public var excerpt: String
	@NSManaged public var artwork: NSNumber
	@NSManaged public var categorias: String
	@NSManaged public var artworkURL: String?
	@NSManaged public var postDisplayDate: String?
	@NSManaged public var postDate: String?
}

// MARK: -
// MARK: - Network Class Extension -

extension Network {
	public class func processJSON(json: [Dictionary<String, Any>]) {

		for data in json {
			// Get only the data we want
			print(json)
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
					return
			}

			Network.getImageURL(host: Site.artworkURL.withParameter(nil), query: "\(artwork)") {
				(result: String?) in

				DispatchQueue.main.async {
					if result != nil {
						UIImageView().kf.setImage(with: URL(string: result!), placeholder: UIImage(named: "image_Logo"))
					}

					let post = Post(id: identifier, postDate: dateString, title: title, content: content, excerpt: excerptHTML, artwork: artwork, categorias: categorias, artworkURL: result)

					Posts.insertOrUpdatePost(post: post)
					DataController.sharedInstance.saveContext()
				}
			}

		}
	}

	public class func processImageJSON(json: Dictionary<String, Any>) -> String? {
		// Get only the data we want
		guard let source_url = json["source_url"] as? String else {
				return nil
		}
		return source_url
	}
}
