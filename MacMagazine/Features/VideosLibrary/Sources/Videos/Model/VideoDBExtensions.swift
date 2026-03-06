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
            read: false,
            favoriteAction: { [weak self] in
                guard let self, let context else { return }
                self.favorite.toggle()
                self.modifiedAt = Date()
                try? context.save()
                analytics?.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.videoFavorite.id,
                    screen: type.screenName
                ))
            },
            readAction: {}
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

extension VideoDB: @retroactive ModelDuplicable {
    public static func deduplicate(using context: ModelContext?) {
        let descriptor = FetchDescriptor<VideoDB>()
        guard let context,
              let data = try? context.fetch(descriptor) else { return }

        let recordsToDelete = Dictionary(grouping: data, by: \.videoId)
            .values
            .flatMap { $0.sorted { $0.modifiedAt > $1.modifiedAt }.dropFirst() }

        recordsToDelete.forEach { context.delete($0) }
        try? context.save()
    }
}
