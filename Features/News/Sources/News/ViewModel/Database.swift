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
            var object = posts[index].asDictionary
            object.removeValue(forKey: "favorite")
            dictionary.addEntries(from: object)
            index += 1
            return false
        })
        batchInsertRequest.resultType = .objectIDs
        return batchInsertRequest
    }
    
    func update(news: News?, favorite: Bool) {
        Task {
            guard let news, let postId = news.postId else { return }
            let predicate = NSPredicate(format: "id == %@", postId)
            guard let status = try? await self.get(predicate: predicate,
                                                   from: "NewsStatus",
                                                   using: mainContext) as? [NewsStatus],
                  let item = status.first else {
                
                let item = NewsStatus(context: mainContext)
                item.id = postId
                item.favorite = favorite
                
                await MainActor.run {
                    try? self.save()
                    mainContext.refresh(news, mergeChanges: true)
                }
                
                return
            }
            
            item.favorite = favorite
            
            await MainActor.run {
                try? self.save()
                mainContext.refresh(news, mergeChanges: true)
            }
        }
    }
    
    func update(id: String, read: Bool) {
        
    }
}

extension News {
    var favorite: Bool {
        let status = value(forKey: "newsStatus") as? [NewsStatus]
        return status?.first?.favorite ?? false
    }
    
    var read: Bool {
        let status = value(forKey: "newsStatus") as? [NewsStatus]
        return status?.first?.read ?? false
    }
    
    var allCategories: String? {
        categories?.joined(separator: "|")
    }
    
    func pubDate(format: MMDateFormat) -> String {
        Date(timeIntervalSinceReferenceDate: pubDate).format(using: format.rawValue)
    }
}

enum MMDateFormat: String {
	case mmDateOnly = "dd/MM"
	case mmDateTime = "dd/MM/yy・HH:mm"
}
