import AnalyticsLibrary
import Foundation
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftData
import YouTubeLibrary

extension VideoDB {
    private var urlToShare: String {
        "https://www.youtube.com/watch?v=\(videoId)"
    }

    func toCardContent(
        using context: ModelContext?,
        analytics: AnalyticsManager?
    ) -> CardContent {
        let type = CardContentType.video(
            views: self.views.formattedBigNumber,
            likes: self.likes.formattedBigNumber,
            duration: self.duration.formattedYTDuration
        )
        return CardContent(
            type: type,
            analytics: analytics,
            title: self.title,
            pubDate: self.pubDate.toDate(),
            artworkUrl: self.artworkURL,
            urlToShare: self.urlToShare,
            favorite: self.favorite,
            favoriteAction: { [weak self] in
                guard let self, let context else { return }
                self.favorite.toggle()
                try? context.save()
                analytics?.track(.buttonTap(buttonId: "favorite_video", screen: type.screenName))
            }
        )
    }
}

extension VideoDB: @retroactive ModelFavoritable {
    public static func deleteNonFavorites(using context: ModelContext?) {
        let descriptor = FetchDescriptor(predicate: #Predicate<VideoDB> { !$0.favorite })
        guard let context,
              let data = try? context.fetch(descriptor) else { return }
        data.forEach { context.delete($0) }
        try? context.save()
    }
}
