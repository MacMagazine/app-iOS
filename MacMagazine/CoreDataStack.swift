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

    func get(page: Int, limit: Int, completion: @escaping ([Post]) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: postEntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]
        request.fetchOffset = page
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

    func delete(_ posts: [String], page: Int) {
        // 1. Retrieve the (posts.count * page) objects from the database
        // 2. Exclude those in both arrays
        // 3. Delete from DB the remaining ids

        // 1.
        get(page: page * posts.count, limit: posts.count) { [weak self] dbPosts in
            let existingIds = dbPosts.map { $0.postId }

            // 2.
            let difference = Array(Set(existingIds).subtracting(posts))

            // 3.
            self?.flush(difference)
        }
    }

    func flush(_ ids: [String?]) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: postEntityName)
        request.predicate = NSPredicate(format: "postId IN %@", ids)

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

            // swiftlint:disable vertical_parameter_alignment_on_call
			return JSONVideo(title: title,
                             videoId: videoId,
                             pubDate: $0.contentDetails?.videoPublishedAt ?? $0.snippet?.publishedAt ?? "",
                             artworkURL: artworkURL,
                             views: views,
                             likes: likes,
                             duration: duration)
            // swiftlint:disable vertical_parameter_alignment_on_call
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

}
