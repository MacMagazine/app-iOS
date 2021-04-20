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

let appTransactionAuthorName = "MacMagazineApp"

class CoreDataStack {

	// MARK: - Singleton -

	static let shared = CoreDataStack()

	// MARK: - Initialization -

	private init() {}

	let postEntityName = "Post"
	let videoEntityName = "Video"
    let settingsEntityName = "Configuration"

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
		let container = NSPersistentCloudKitContainer(name: "macmagazine")

        // Enable history tracking and remote notifications
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        container.loadPersistentStores { _, error in
            guard let error = error as NSError? else {
                return
            }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.transactionAuthor = appTransactionAuthorName

        // Pin the viewContext to the current generation token and set it to keep itself up to date with local changes.
        container.viewContext.automaticallyMergesChangesFromParent = true

        // Observe Core Data remote change notifications.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(type(of: self).storeRemoteChange(_:)),
                                               name: .NSPersistentStoreRemoteChange,
                                               object: container.persistentStoreCoordinator)

        return container
	}()

    // An operation queue for handling history processing tasks: watching changes, deduplicating, and triggering UI updates if needed.
    private lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}

    // Track the last history token processed for a store, and write its value to file.
    // The historyQueue reads the token when executing operations, and updates it after processing is complete.
    private var lastHistoryToken: NSPersistentHistoryToken? = nil {
        didSet {
            guard let token = lastHistoryToken,
                  let data = try? NSKeyedArchiver.archivedData( withRootObject: token, requiringSecureCoding: true) else { return }

            do {
                try data.write(to: tokenFile)
            } catch {
                logE(error.localizedDescription)
            }
        }
    }

    // The file URL for persisting the persistent history token.
    private lazy var tokenFile: URL = {
        let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent(appTransactionAuthorName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                logE(error.localizedDescription)
            }
        }
        return url.appendingPathComponent("token.data", isDirectory: false)
    }()

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

		do {
			let result = try viewContext.execute(deleteRequest) as? NSBatchDeleteResult
			guard let objectIDs = result?.result as? [NSManagedObjectID] else {
				return
			}

			// Updates the main context
			NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs], into: [self.viewContext])

		} catch {
			fatalError("Failed to execute request: \(error)")
		}
	}

	// MARK: - Entity Post -

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

    func get<T>(predicate: NSPredicate?, entity: String, context: NSManagedObjectContext, completion: @escaping ([T]) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]

        if let predicate = predicate {
            request.predicate = predicate
        }

        // Creates `asynchronousFetchRequest` with the fetch request and the completion closure
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) { asynchronousFetchResult in
            guard let result = asynchronousFetchResult.finalResult as? [T] else {
                completion([])
                return
            }
            completion(result)
        }

        do {
            try context.execute(asynchronousFetchRequest)
        } catch let error {
            logE(error.localizedDescription)
        }
    }

	func get(predicate: NSPredicate?, completion: @escaping ([Post]) -> Void) {
        get(predicate: predicate, entity: postEntityName, context: viewContext, completion: completion)
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
            completion(categories)
        }
    }

	// MARK: - Entity Video -

	func get(video videoId: String, completion: @escaping ([Video]) -> Void) {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: videoEntityName)
		request.predicate = NSPredicate(format: "videoId == %@", videoId)

		// Creates `asynchronousFetchRequest` with the fetch request and the completion closure
		let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) { asynchronousFetchResult in
			guard let result = asynchronousFetchResult.finalResult as? [Video] else {
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

	func save(playlist: YouTube<String>, statistics: [Item<String>]) {
		// Cannot duplicate videos
		guard let videos = playlist.items else {
			return
		}

		let mappedVideos: [JSONVideo] = videos.compactMap {
			guard let title = $0.snippet?.title,
				let videoId = $0.snippet?.resourceId?.videoId
				else {
					return nil
			}

			var likes = ""
			var views = ""
			var duration = ""
			let stat = statistics.filter {
				$0.id == videoId
			}
			if !stat.isEmpty {
				views = stat[0].statistics?.viewCount ?? ""
				likes = stat[0].statistics?.likeCount ?? ""
				duration = stat[0].contentDetails?.duration ?? ""
			}

			let artworkURL = $0.snippet?.thumbnails?.maxres?.url ?? $0.snippet?.thumbnails?.high?.url ?? ""

			return JSONVideo(title: title, videoId: videoId, pubDate: $0.snippet?.publishedAt ?? "", artworkURL: artworkURL, views: views, likes: likes, duration: duration)
		}

		mappedVideos.forEach { video in
			get(video: video.videoId) { items in
				if items.isEmpty {
					self.insert(video: video)
				} else {
					self.update(video: items[0], with: video)
				}
				self.save()
			}
		}
	}

	func insert(video: JSONVideo) {
		let newItem = Video(context: viewContext)
		newItem.favorite = false
		newItem.title = video.title
		newItem.artworkURL = video.artworkURL.escape()
		newItem.pubDate = video.pubDate.toDate(Format.youtube)
		newItem.videoId = video.videoId
		newItem.likes = video.likes
		newItem.views = video.views
		newItem.duration = video.duration
	}

	func update(video: Video, with item: JSONVideo) {
		video.title = item.title
		video.artworkURL = item.artworkURL.escape()
		video.pubDate = item.pubDate.toDate(Format.youtube)
		video.videoId = item.videoId
		video.likes = item.likes
		video.views = item.views
		video.duration = item.duration
	}

    // MARK: - Entity settings -

    fileprivate func fetch() -> Configuration? {
        var settings: [Configuration]?

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: settingsEntityName)

        do {
            settings = try viewContext.fetch(request) as? [Configuration]
        } catch let error {
            logE(error.localizedDescription)
        }

        return settings?.first
    }

    var migrated: Bool {
        get {
            return fetch()?.migrated ?? false
        }
        set(value) {
            guard let settings = fetch() else {
                let settings = Configuration(context: viewContext)
                settings.migrated = value
                save()
                return
            }
            settings.migrated = value
            save()
        }
    }

    var allPushes: Bool {
        get {
            return fetch()?.allPushes ?? false
        }
        set(value) {
            guard let settings = fetch() else {
                let settings = Configuration(context: viewContext)
                settings.allPushes = value
                save()
                return
            }
            settings.allPushes = value
            save()
        }
    }

    var purchased: Bool {
        get {
            return fetch()?.purchased ?? false
        }
        set(value) {
            guard let settings = fetch() else {
                let settings = Configuration(context: viewContext)
                settings.purchased = value
                save()
                return
            }
            settings.purchased = value
            save()
        }
    }

    var patrao: Bool {
        get {
            return fetch()?.patrao ?? false
        }
        set(value) {
            guard let settings = fetch() else {
                let settings = Configuration(context: viewContext)
                settings.patrao = value
                save()
                return
            }
            settings.patrao = value
            save()
        }
    }

    var transparency: Float {
        get {
            return fetch()?.transparency ?? 0.5
        }
        set(value) {
            guard let settings = fetch() else {
                let settings = Configuration(context: viewContext)
                settings.transparency = value
                save()
                return
            }
            settings.transparency = value
            save()
        }
    }
}

// MARK: - Notifications -

extension CoreDataStack {
    /**
     Handle remote store change notifications (.NSPersistentStoreRemoteChange).
     */
    @objc
    fileprivate func storeRemoteChange(_ notification: Notification) {
        processDuplicates()

        // Process persistent history to merge changes from other coordinators.
        historyQueue.addOperation {
            self.processPersistentHistory()
        }
    }

}

// MARK: - Persistent history processing -

extension CoreDataStack {

    fileprivate struct DeDuplicate {
        var name: String
        var objectId: NSManagedObjectID
    }

    // Process persistent history, posting any relevant transactions to the current view.
    fileprivate func processPersistentHistory() {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.performAndWait {

            // Fetch history received from outside the app since the last token
            guard let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest else { return }
            historyFetchRequest.predicate = NSPredicate(format: "author != %@", appTransactionAuthorName)
            let request = NSPersistentHistoryChangeRequest.fetchHistory(after: lastHistoryToken)
            request.fetchRequest = historyFetchRequest

            let result = (try? taskContext.execute(request)) as? NSPersistentHistoryResult
            guard let transactions = result?.result as? [NSPersistentHistoryTransaction],
                  !transactions.isEmpty else { return }

            // Deduplicate objects.
            var newObjectIDs = [DeDuplicate]()

            for transaction in transactions where transaction.changes != nil {
                transaction.changes?.forEach { change in
                    if change.changeType == .insert,
                       let name = change.changedObjectID.entity.name {
                        newObjectIDs.append(DeDuplicate(name: name, objectId: change.changedObjectID))
                    }
                }
            }

            if !newObjectIDs.isEmpty {
                deduplicateAndWait(objects: newObjectIDs)
            }

            // Update the history token using the last transaction.
            lastHistoryToken = transactions.last?.token
        }
    }
}

// MARK: - Deduplicate -

extension CoreDataStack {
    // Deduplicate tags with the same name by processing the persistent history, one object at a time, on the historyQueue.
    // All peers should eventually reach the same result with no coordination or communication.
    fileprivate func deduplicateAndWait(objects: [DeDuplicate]) {
        // Make any store changes on a background context
        let taskContext = persistentContainer.backgroundContext()

        // Use performAndWait because each step relies on the sequence. Since historyQueue runs in the background, waiting won’t block the main queue.
        taskContext.performAndWait {
            objects.forEach { object in
                self.deduplicate(object: object, performingContext: taskContext)
            }
            // Save the background context to trigger a notification and merge the result into the viewContext.
            save(taskContext)
        }
    }

    // Deduplicate a single object.
    fileprivate func deduplicate(object: DeDuplicate, performingContext: NSManagedObjectContext) {
        switch object.name {
            case Post.entity().name:
                deduplicatePost(object: object, performingContext: performingContext)

            case Video.entity().name:
                deduplicateVideo(object: object, performingContext: performingContext)

            case Configuration.entity().name:
                deduplicateConfiguration(performingContext: performingContext)

            default:
                break
        }
    }

    fileprivate func deduplicatePost(object: DeDuplicate, performingContext: NSManagedObjectContext) {
        guard let post = performingContext.object(with: object.objectId) as? Post,
              let postId = post.postId else { return }

        // Fetch all objects with the same postId
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "postId == %@", postId)

        // Return if there are no duplicates.
        guard var duplicated = try? performingContext.fetch(fetchRequest),
              duplicated.count > 1 else { return }

        // Pick the first object as the winner.
        duplicated.removeFirst()
        duplicated.forEach { object in
            do { performingContext.delete(object) }
        }
    }

    fileprivate func deduplicateVideo(object: DeDuplicate, performingContext: NSManagedObjectContext) {
        guard let video = performingContext.object(with: object.objectId) as? Video,
              let videoId = video.videoId else { return }

        // Fetch all objects with the same videoId
        let fetchRequest: NSFetchRequest<Video> = Video.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "videoId == %@", videoId)

        // Return if there are no duplicates.
        guard var duplicated = try? performingContext.fetch(fetchRequest),
              duplicated.count > 1 else { return }

        // Pick the first object as the winner.
        duplicated.removeFirst()
        duplicated.forEach { object in
            do { performingContext.delete(object) }
        }
    }

    fileprivate func deduplicateConfiguration(performingContext: NSManagedObjectContext) {
        // Fetch all objects with the same key
        let fetchRequest: NSFetchRequest<Configuration> = Configuration.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "key == %@", appTransactionAuthorName)

        // Return if there are no duplicates.
        guard var duplicated = try? performingContext.fetch(fetchRequest),
              duplicated.count > 1 else { return }

        // Pick the first object as the winner.
        duplicated.removeFirst()
        duplicated.forEach { object in
            do { performingContext.delete(object) }
        }
    }
}

extension NSPersistentContainer {
    func backgroundContext() -> NSManagedObjectContext {
        let context = newBackgroundContext()
        context.transactionAuthor = appTransactionAuthorName
        return context
    }
}

extension CoreDataStack {
    fileprivate func getDuplicates(in context: NSManagedObjectContext, entity: String, key: String) -> [[String: AnyObject]]? {
        var expressionDescriptions = [AnyObject]()
        expressionDescriptions.append(key as AnyObject)

        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "count"
        expressionDescription.expression = NSExpression(forFunction: "count:", arguments: [NSExpression(forKeyPath: key)])
        expressionDescription.expressionResultType = .integer32AttributeType
        expressionDescriptions.append(expressionDescription)

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.propertiesToGroupBy = [key]
        request.resultType = .dictionaryResultType
        request.sortDescriptors = [NSSortDescriptor(key: key, ascending: true)]
        request.propertiesToFetch = expressionDescriptions

        var results: [[String: AnyObject]]?

        do {
            results = try context.fetch(request) as? [[String: AnyObject]]
        } catch _ {
            results = nil
        }

        return results?.filter { ($0["count"] as? Int) ?? 0 > 1 }
    }

    fileprivate func getDuplicatedPosts(in context: NSManagedObjectContext) -> [[String: AnyObject]]? {
        return getDuplicates(in: context, entity: postEntityName, key: "postId")
    }

    fileprivate func getDuplicatedVideos(in context: NSManagedObjectContext) -> [[String: AnyObject]]? {
        return getDuplicates(in: context, entity: videoEntityName, key: "videoId")
    }

    fileprivate func processDuplicates() {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.performAndWait {
            getDuplicatedPosts(in: taskContext)?.forEach { duplicates in
                guard let postId = duplicates["postId"] as? String else { return }
                get(predicate: NSPredicate(format: "postId == %@", postId),
                    entity: postEntityName,
                    context: taskContext) { (posts: [Post]) in

                    var duplicated = posts
                    duplicated.removeFirst()
                    duplicated.forEach { object in
                        do { taskContext.delete(object) }
                    }
                    try? taskContext.save()
                }
            }

            getDuplicatedVideos(in: taskContext)?.forEach { duplicates in
                guard let videoId = duplicates["videoId"] as? String else { return }
                get(predicate: NSPredicate(format: "videoId == %@", videoId),
                    entity: videoEntityName,
                    context: taskContext) { (videos: [Video]) in

                    var duplicated = videos
                    duplicated.removeFirst()
                    duplicated.forEach { object in
                        do { taskContext.delete(object) }
                    }
                    try? taskContext.save()
                }
            }

            deduplicateConfiguration(performingContext: taskContext)
        }
    }
}
