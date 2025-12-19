import AnalyticsLibrary
import FeedLibrary
import Foundation
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftData

extension PodcastDB {
    func toCardContent(
        using context: ModelContext?,
        analytics: AnalyticsManager?,
        screen: String?
    ) -> CardContent {
        let type = CardContentType.podcast(duration: self.duration)
        return CardContent(
            type: type,
            analytics: analytics,
            title: self.title,
            pubDate: self.pubDate,
            artworkUrl: self.artworkURL,
            urlToShare: self.link,
            favorite: self.favorite,
            favoriteAction: { [weak self] in
                guard let self, let context else { return }
                self.favorite.toggle()
                try? context.save()
                analytics?.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.podcastFavorite.id,
                    screen: screen ?? type.screenName
                ))
            }
        )
    }

    func save(current: Double, using context: ModelContext?) {
        guard let context else { return }
        self.current = current
        try? context.save()
    }
}
