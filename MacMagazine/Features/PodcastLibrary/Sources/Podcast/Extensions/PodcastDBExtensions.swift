import AnalyticsLibrary
import FeedLibrary
import Foundation
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftData

public extension PodcastDB {
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
            read: false,
            favoriteAction: { [weak self] in
                guard let self, let context else { return }
                self.favorite.toggle()
                self.modifiedAt = Date()
                try? context.save()
                analytics?.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.podcastFavorite.id,
                    screen: screen ?? type.screenName
                ))
            },
            readAction: {}
        )
    }

    func save(current: Double, using context: ModelContext?) {
        guard let context else { return }
        self.current = current
        self.modifiedAt = Date()
        try? context.save()
    }
}
