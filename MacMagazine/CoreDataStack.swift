//
//  CoreDataStack.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 23/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import CoreData
import Foundation

enum FlushType {
    case all
    case keepFavorite
    case keepReadStatus
    case keepAllStatus
    case imagesOnly
}

extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}

class CoreDataStack {

	// MARK: - Singleton -

	static let shared = CoreDataStack()

	// MARK: - Initialization -

	private init() {}

	let postEntityName = "Post"
	let videoEntityName = "Video"

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "macmagazine")

        #if TEST
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        #else
        let source = container.persistentStoreDescriptions.first?.url

        let appGroupStoreURL = URL.storeURL(for: "group.com.brit.macmagazine.data", databaseName: "group.macmagazine")
        let storeDescription = NSPersistentStoreDescription(url: appGroupStoreURL)
        container.persistentStoreDescriptions = [storeDescription]

        if let source = source,
            FileManager.default.fileExists(atPath: source.path) {
            logI("Migration required")

            // Migrate DB
            migrateStore(container, from: source, to: appGroupStoreURL)
        }
        #endif

        container.loadPersistentStores { _, error in
			guard let error = error as NSError? else {
				return
			}
			fatalError("Unresolved error: \(error), \(error.userInfo)")
		}

        // To prevent duplicates, ignore any object that came later
		container.viewContext.mergePolicy = NSRollbackMergePolicy
		return container
	}()

	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}

	// MARK: - Context Methods -

	func save() {
		save(nil)
        Helper().showBadge()
	}

	func save(_ context: NSManagedObjectContext?) {
		let desiredContext = context ?? viewContext
		if desiredContext.hasChanges {
			do {
				try desiredContext.save()
			} catch {
				logE(error.localizedDescription)
			}
		}
	}

	func links(_ completion: @escaping ([PostData]) -> Void) {
		getAll { posts in
			var response = [PostData]()
			for post in posts {
				response.append(PostData(title: post.title, link: post.link, thumbnail: post.artworkURL, favorito: post.favorite))
			}
			completion(response)
		}
	}

    func flush(type: FlushType) {
        flush(entityName: postEntityName, type: type)
		flush(entityName: videoEntityName, type: type)
	}

	func flush(entityName: String, type: FlushType) {
        if type == .imagesOnly {
            return
        }

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        if type != .all &&
            entityName == postEntityName {

            let readPredicate = NSPredicate(format: "read == %@", NSNumber(value: false))
            let favoritePredicate = NSPredicate(format: "favorite == %@", NSNumber(value: false))

            if type == .keepReadStatus {
                request.predicate = readPredicate
            }
            if type == .keepFavorite {
                request.predicate = favoritePredicate
            }
            if type == .keepAllStatus {
                request.predicate = NSCompoundPredicate(type: .and,
                                                        subpredicates: [readPredicate, favoritePredicate])
            }
        }
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
		deleteRequest.resultType = .resultTypeObjectIDs

        logD(request.predicate)

		do {
			let result = try viewContext.execute(deleteRequest) as? NSBatchDeleteResult
			guard let objectIDs = result?.result as? [NSManagedObjectID] else {
				return
			}

            logD(objectIDs)

            if !objectIDs.isEmpty {
                // Updates the main context
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs], into: [self.viewContext])
            }
		} catch {
			fatalError("Failed to execute request: \(error)")
		}
	}

	// MARK: - Entity Posts -

	func getPostsForWatch(completion: @escaping ([PostData]) -> Void) {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: postEntityName)
		request.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]
		request.fetchLimit = 10

		// Creates `asynchronousFetchRequest` with the fetch request and the completion closure
		let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) { asynchronousFetchResult in
			guard let result = asynchronousFetchResult.finalResult as? [Post] else {
				return
			}
			let watchPosts = result.map {
				PostData(title: $0.title, link: $0.link, thumbnail: $0.artworkURL, favorito: false, pubDate: $0.pubDate?.watchDate(), excerpt: $0.excerpt)
			}
			completion(watchPosts)
		}

		do {
			try viewContext.execute(asynchronousFetchRequest)
		} catch let error {
			logE(error.localizedDescription)
		}
	}

	func getAll(_ completion: @escaping ([Post]) -> Void) {
		get(predicate: nil, completion: completion)
	}

	func get(link: String, completion: @escaping ([Post]) -> Void) {
		get(predicate: NSPredicate(format: "link == %@", link), completion: completion)
	}

    func get(link: String, completion: @escaping ([PostData]) -> Void) {
        get(link: link) { (posts: [Post]) in
            let response = posts.map {
                PostData(title: $0.title, link: $0.link, thumbnail: $0.artworkURL, favorito: $0.favorite, postId: $0.postId, shortURL: $0.shortURL)
            }
            completion(response)
        }
    }

	func get(post: XMLPost, completion: @escaping ([Post]) -> Void) {
        let link = NSPredicate(format: "link == %@", post.link)
        let postId = NSPredicate(format: "postId == %@", post.postId)
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [link, postId])
        get(predicate: predicate, completion: completion)
	}

	func get(predicate: NSPredicate?, completion: @escaping ([Post]) -> Void) {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: postEntityName)
		request.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]

		if let predicate = predicate {
			request.predicate = predicate
		}

		// Creates `asynchronousFetchRequest` with the fetch request and the completion closure
		let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) { asynchronousFetchResult in
			guard let result = asynchronousFetchResult.finalResult as? [Post] else {
				completion([])
				return
			}
			completion(result)
		}

		do {
			try viewContext.execute(asynchronousFetchRequest)
		} catch let error {
			logE(error.localizedDescription)
		}
	}

	func save(post: XMLPost) {
		// Cannot duplicate links
		get(post: post) { [weak self] items in
            guard let self = self else {
				return
			}
			if items.isEmpty {
                self.insert(post: post)
			} else {
				self.update(post: items[0], with: post)
			}
			self.save()
		}
	}

	func insert(post: XMLPost) {
		let newItem = Post(context: viewContext)
		newItem.title = post.title
		newItem.link = post.link
		newItem.excerpt = post.excerpt.toHtmlDecoded()
		newItem.artworkURL = post.artworkURL.escape()
		newItem.categorias = post.getCategorias()
		newItem.pubDate = post.pubDate.toDate()
		newItem.podcast = post.podcast
		newItem.podcastURL = post.podcastURL
		newItem.duration = post.duration
		newItem.headerDate = post.pubDate.toDate().sortedDate()
		newItem.favorite = false
        newItem.podcastFrame = post.podcastFrame
		newItem.postId = post.postId
        newItem.read = false
        newItem.shortURL = post.shortURL
        newItem.playable = post.playable || !post.duration.isEmpty
    }

	func update(post: Post, with item: XMLPost) {
		post.title = item.title
		post.link = item.link
		post.excerpt = item.excerpt.toHtmlDecoded()
		post.artworkURL = item.artworkURL.escape()
		post.categorias = item.getCategorias()
		post.pubDate = item.pubDate.toDate()
		post.podcast = item.podcast
		post.podcastURL = item.podcastURL
		post.duration = item.duration
		post.headerDate = item.pubDate.toDate().sortedDate()
        post.podcastFrame = item.podcastFrame
		post.postId = item.postId
        post.shortURL = item.shortURL
        post.playable = item.playable || !item.duration.isEmpty
    }

    func get(limit: Int, completion: @escaping ([Post]) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: postEntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]
        request.fetchLimit = limit

        // Creates `asynchronousFetchRequest` with the fetch request and the completion closure
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) { asynchronousFetchResult in
            guard let result = asynchronousFetchResult.finalResult as? [Post] else {
                completion([])
                return
            }
            completion(result)
        }

        do {
            try viewContext.execute(asynchronousFetchRequest)
        } catch let error {
            logE(error.localizedDescription)
        }
    }

    // Delete temporary posts
    func delete(_ posts: [String]) {
        // 1. Retrieve the (posts.count) objects from the database
        // 2. Exclude those in both arrays keeping flags (read/favorite)
        // 3. Delete from DB the remaining ids

        logD("limit: \(posts.count)")

        // 1.
        get(limit: posts.count) { [weak self] dbPosts in
            let existingIds: [String] = dbPosts.compactMap { $0.postId }
            let xxx: [String] = dbPosts.compactMap { "(\(String(describing: $0.postId))) \(String(describing: $0.title))" }

            logD("posts: \(posts.joined(separator: ", "))")
            logD("existingIds: \(existingIds.joined(separator: ", "))")
            logD("xxx: \(xxx.joined(separator: ", "))")

            // 2.
            let difference = Array(Set(existingIds).subtracting(posts))
            logD("difference: \(difference.joined(separator: ", "))")

            // 3.
            if !difference.isEmpty {
                self?.flush(difference)
            }
        }
    }

    func flush(_ ids: [String]) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: postEntityName)
        request.predicate = NSPredicate(format: "postId IN %@", ids)

        logD(request.predicate)

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        deleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try viewContext.execute(deleteRequest) as? NSBatchDeleteResult
            guard let objectIDs = result?.result as? [Post] else {
                return
            }

            // Updates the main context
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs], into: [self.viewContext])
            self.save()

        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }

    func getCategories(completion: @escaping ([String]) -> Void) {
        var categories = [String]()
        getAll { posts in
            posts.forEach {
                guard let dbCategories = $0.categorias?.components(separatedBy: ",") else {
                    return
                }
                categories.append(contentsOf: dbCategories)
            }
            completion(Array(Set(categories)).sorted {
                $0.compare($1, locale: Locale(identifier: "pt-BR")) == .orderedAscending
            })
        }
    }
}

extension CoreDataStack {
    func numberOfUnreadPosts() -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: postEntityName)
        request.predicate = NSPredicate(format: "read == %@", NSNumber(value: false))

        do {
            return try viewContext.count(for: request)
        } catch {
            return 0
        }
    }

    func read(_ type: FlushType, onCompletion: (() -> Void)?) {
        let batchRequest = NSBatchUpdateRequest(entityName: postEntityName)
        batchRequest.resultType = .updatedObjectIDsResultType
        batchRequest.propertiesToUpdate = ["read": NSNumber(value: true)]

        do {
            let result = try viewContext.execute(batchRequest) as? NSBatchUpdateResult
            guard let objectIDs = result?.result as? [NSManagedObjectID] else {
                return
            }
            if !objectIDs.isEmpty {
                // Updates the main context
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSUpdatedObjectsKey: objectIDs], into: [self.viewContext])
            }
            onCompletion?()
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }
}

extension CoreDataStack {
    fileprivate func migrateStore(_ container: NSPersistentContainer,
                                  from: URL,
                                  to: URL) {

        for persistentStoreDescription in container.persistentStoreDescriptions {
            do {
                  try container.persistentStoreCoordinator.replacePersistentStore(at: to,
                                                                                  destinationOptions: persistentStoreDescription.options,
                                                                                  withPersistentStoreFrom: from,
                                                                                  sourceOptions: persistentStoreDescription.options,
                                                                                  ofType: persistentStoreDescription.type)
              } catch {
                  logE("Failed to copy persistence store: \(error.localizedDescription)")
              }
        }

        do {
            logI("Remove old store")
            try FileManager.default.removeItem(at: from)
        } catch {
            fatalError("Something went wrong while deleting the old store: \(error.localizedDescription)")
        }

    }
}
