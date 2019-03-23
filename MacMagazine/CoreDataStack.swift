//
//  CoreDataStack.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 23/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import CoreData
import Foundation

class CoreDataStack {

	// MARK: - Singleton -

	static let shared = CoreDataStack()

	// MARK: - Initialization -

	private init() {}

	let entityName = "Post"

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "macmagazine")
		container.loadPersistentStores { _, error in
			guard let error = error as NSError? else {
				return
			}
			fatalError("Unresolved error: \(error), \(error.userInfo)")
		}

		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		container.viewContext.undoManager = nil
		container.viewContext.shouldDeleteInaccessibleFaults = true
		container.viewContext.automaticallyMergesChangesFromParent = true

		return container
	}()

	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}

	// MARK: - Context Methods -

	func save() {
		save(nil)
	}

	func save(_ context: NSManagedObjectContext?) {
		let desiredContext = context ?? viewContext
		if desiredContext.hasChanges {
			do {
				try desiredContext.save()
			} catch {
				print(error)
			}
		}
	}

	func flush() {
		persistentContainer.performBackgroundTask { privateManagedObjectContext in
			let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
			let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
			deleteRequest.resultType = .resultTypeObjectIDs

			do {
				let result = try privateManagedObjectContext.execute(deleteRequest) as? NSBatchDeleteResult
				guard let objectIDs = result?.result as? [NSManagedObjectID] else {
					return
				}

				// Updates the main context
				NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs], into: [self.viewContext])

			} catch {
				fatalError("Failed to execute request: \(error)")
			}
		}
	}

	func get(post link: String, completion: @escaping ([Post], NSManagedObjectContext) -> Void) {
		let privateManagedObjectContext = persistentContainer.newBackgroundContext()
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		request.predicate = NSPredicate(format: "link == %@", link)

		// Creates `asynchronousFetchRequest` with the fetch request and the completion closure
		let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) { asynchronousFetchResult in
			guard let result = asynchronousFetchResult.finalResult as? [Post] else {
				completion([], privateManagedObjectContext)
				return
			}
			completion(result, privateManagedObjectContext)
		}

		do {
			try privateManagedObjectContext.execute(asynchronousFetchRequest)
		} catch let error {
			print("NSAsynchronousFetchRequest error: \(error)")
		}
	}

	func save(post: XMLPost) {
		// Cannot duplicate links
		get(post: post.link) { items, context in
			if items.isEmpty {
				self.insert(post: post)
			} else {
				self.update(post: items[0], with: post)
				self.save(context)
			}
		}
	}

	func insert(post: XMLPost) {
		persistentContainer.performBackgroundTask { privateManagedObjectContext in
			let newItem = Post(context: privateManagedObjectContext)
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

			self.save(privateManagedObjectContext)
		}
	}

	func update(post: Post, with item: XMLPost) {
		post.title = item.title
		post.link = item.link
		post.excerpt = item.excerpt
		post.artworkURL = item.artworkURL
		post.categorias = item.getCategorias()
		post.pubDate = item.pubDate.toDate(nil)
		post.podcast = item.podcast
		post.podcastURL = item.podcastURL
		post.duration = item.duration
		post.headerDate = item.pubDate.toDate(nil).sortedDate()
	}

}
