import Foundation
import MacMagazineLibrary
import SwiftData
import YouTubeLibrary

extension VideoDB: @retroactive ModelFavoritable {
    public static func deleteNonFavorites(using context: ModelContext?) {
        let descriptor = FetchDescriptor(predicate: #Predicate<VideoDB> { !$0.favorite })
        guard let context,
              let data = try? context.fetch(descriptor) else { return }
        data.forEach { context.delete($0) }
        try? context.save()
    }
}
