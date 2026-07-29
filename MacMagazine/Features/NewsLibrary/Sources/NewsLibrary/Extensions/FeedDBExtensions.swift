import AnalyticsLibrary
import FeedLibrary
import Foundation
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftData

public extension FeedDB {
    func toCardContent(
        using context: ModelContext?,
        analytics: AnalyticsManager?,
        screen: String?,
        style: CardStyle?,
        aspectRatio: CGFloat? = 16 / 9,
        titleLines: Int = 3
    ) -> CardContent {
        let type = CardContentType.news(
            categories: self.categories.toNewsCategory,
            style: style)
        return CardContent(
            type: type,
            analytics: analytics,
            title: self.title,
            titleLines: titleLines,
            pubDate: self.pubDate,
            author: self.author,
            artworkUrl: self.artworkURL,
            urlToShare: self.link,
            favorite: self.favorite,
            read: self.read,
            aspectRatio: aspectRatio,
            favoriteAction: { [weak self] in
                guard let self, let context else { return }
                self.toggleFavorite()
                try? context.save()
                analytics?.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.newsFavorite.id,
                    screen: screen ?? type.screenName
                ))
            },
            readAction: { [weak self] in
                guard let self, let context else { return }
                self.toggleRead()
                try? context.save()
            }
        )
    }
}
