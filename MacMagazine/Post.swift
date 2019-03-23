//
//  Post.swift
//
//  Created by Cassio Rossi on 22/09/16.
//  Copyright © 2016 Cassio Rossi. All rights reserved.
//

import CoreData
import UIKit

// MARK: - Core Data Methods -

@objc(Posts)
public class Posts: NSManagedObject {

	class func getPost(byLink: String) -> [Posts] {
		var item = [Posts]()

		do {
			// Execute the fetch request
			let request: NSFetchRequest<Posts> = Posts.fetchRequest()
			request.predicate = NSPredicate(format: "link == %@", byLink)

			let results = try self.managedObjectContext().fetch(request)
			item = results

		} catch let error as NSError {
			print("\(error), \(error.userInfo)")
		}

		return item
	}

	class func insertOrUpdatePost(post: XMLPost) {
		// Cannot duplicate links
		let item = self.getPost(byLink: post.link)
		if item.isEmpty {
			guard let newItem = NSEntityDescription.insertNewObject(forEntityName: self.entityName(), into: self.managedObjectContext()) as? Posts else {
				return
			}
			newItem.title = post.title
			newItem.link = post.link
			newItem.excerpt = post.excerpt
			newItem.artworkURL = post.artworkURL
			newItem.categorias = post.getCategorias()
			newItem.pubDate = post.pubDate.toDate(nil)
			newItem.podcast = post.podcast
			newItem.podcastURL = post.podcastURL
			newItem.duration = post.duration
			newItem.headerDate = post.pubDate.toDate(nil).sortedDate()
			newItem.favorite = false

		} else {
			item[0].title = post.title
			item[0].link = post.link
			item[0].excerpt = post.excerpt
			item[0].artworkURL = post.artworkURL
			item[0].categorias = post.getCategorias()
			item[0].pubDate = post.pubDate.toDate(nil)
			item[0].podcast = post.podcast
			item[0].podcastURL = post.podcastURL
			item[0].duration = post.duration
			item[0].headerDate = post.pubDate.toDate(nil).sortedDate()
		}
	}

	class func deleteAll() {
		DispatchQueue.main.async {
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName())
			fetchRequest.returnsObjectsAsFaults = false
			do {
				let results = try self.managedObjectContext().fetch(fetchRequest)
				for object in results {
					guard let objectData = object as? NSManagedObject else {
						continue
					}
					self.managedObjectContext().delete(objectData)
				}
			} catch {
				print("Detele all data error:", error)
			}
		}
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

	@NSManaged public var artworkURL: String
	@NSManaged public var categorias: String
	@NSManaged public var excerpt: String
	@NSManaged public var headerDate: String
	@NSManaged public var pubDate: Date
	@NSManaged public var title: String
	@NSManaged public var duration: String
	@NSManaged public var link: String
	@NSManaged public var podcast: String
	@NSManaged public var podcastURL: String
	@NSManaged public var favorite: Bool

}
