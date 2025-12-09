import FeedLibrary
import Foundation
import MacMagazineUILibrary
import SwiftData

extension PodcastDB {
    func toCardContent(using context: ModelContext?) -> CardContent {
        CardContent(
            type: .podcast(duration: self.duration),
            title: self.title,
            pubDate: self.pubDate,
            artworkUrl: self.artworkURL,
            urlToShare: self.podcastURL,
            favorite: self.favorite,
            favoriteAction: { [weak self] in
                guard let self, let context else { return }
                self.favorite.toggle()
                try? context.save()
            }
        )
    }
}
