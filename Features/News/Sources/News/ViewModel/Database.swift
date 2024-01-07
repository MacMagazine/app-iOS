import CoreData
import CoreLibrary

extension Database {
	func save(_ news: [XMLPost]) {
		Task {
			await context.perform {
				do {
					let batchInsertRequest = self.batchInsertRequest(with: news)
					if let batchInsertResult = try context.execute(batchInsertRequest) as? NSBatchInsertResult,
					   let objectIDs = batchInsertResult.result as? [NSManagedObjectID], !objectIDs.isEmpty {
						NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSInsertedObjectsKey: objectIDs], into: [mainContext])
						return
					}
				} catch {
					print(error)
				}
			}
		}
	}

	private func batchInsertRequest(with posts: [XMLPost]) -> NSBatchInsertRequest {
		var index = 0
		let total = posts.count

		// Provide one dictionary at a time when the closure is called.
		let batchInsertRequest = NSBatchInsertRequest(entity: News.entity(), dictionaryHandler: { dictionary in
			guard index < total else { return true }
			dictionary.addEntries(from: posts[index].asDictionary)
			index += 1
			return false
		})
		batchInsertRequest.resultType = .objectIDs
		return batchInsertRequest
	}
}

extension News {
	func pubDate(format: MMDateFormat) -> String {
		Date(timeIntervalSinceReferenceDate: pubDate).format(using: format.rawValue)
	}

	var allCategories: String? {
		categories?.joined(separator: "|")
	}
}

enum MMDateFormat: String {
	case mmDateOnly = "dd/MM"
	case mmDateTime = "dd/MM/yy・HH:mm"
}
