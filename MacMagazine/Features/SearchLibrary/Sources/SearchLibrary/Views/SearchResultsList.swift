import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import PodcastLibrary
import SwiftData
import SwiftUI
import YouTubeLibrary

struct SearchResultsList: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var analytics: AnalyticsManager

    let results: [SearchResult]
    let onSelectNews: (FeedDB) -> Void
    let onSelectPodcast: (PodcastDB) -> Void
    let onSelectVideo: (VideoDB) -> Void
    let onSelectLink: (String) -> Void

    var body: some View {
        ForEach(results) { result in
            resultCard(for: result)
        }
    }
}

// MARK: - Cards

private extension SearchResultsList {

    @ViewBuilder
    func resultCard(for result: SearchResult) -> some View {
        switch result.type {
        case .news:
            newsCard(for: result)
        case .podcast:
            podcastCard(for: result)
        case .video:
            videoCard(for: result)
        }
    }
}

// MARK: - Card Types

private extension SearchResultsList {

    @ViewBuilder
    func newsCard(for result: SearchResult) -> some View {
        let feedDB = result.feedDB
        let categories = result.categories.compactMap { categoryName in
            NewsCategory.allCases.first { $0.filterKey == categoryName }
        }
        let cardContent = CardContent(
            type: .news(
                categories: categories,
                style: categories.mostRelevant.style
            ),
            analytics: analytics,
            title: result.title,
            pubDate: result.pubDate,
            author: result.author,
            artworkUrl: result.artworkURL,
            urlToShare: result.link,
            favorite: result.favorite,
            favoriteAction: {
                guard let feedDB else { return }
                feedDB.favorite.toggle()
                feedDB.modifiedAt = Date()
                try? modelContext.save()
            }
        )

        NewsCard(data: cardContent) {
            if let feedDB {
                onSelectNews(feedDB)
            } else {
                onSelectLink(result.link)
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    func podcastCard(for result: SearchResult) -> some View {
        if let podcastDB = result.podcastDB {
            AdaptivePodcastCardView(
                podcast: podcastDB.toCardContent(
                    using: modelContext,
                    analytics: analytics,
                    screen: nil
                )
            ) {
                onSelectPodcast(podcastDB)
            }
            .padding(.horizontal)
        } else {
            // Remote podcast without local data — fall back to web
            let cardContent = CardContent(
                type: .podcast(duration: result.duration ?? ""),
                analytics: analytics,
                title: result.title,
                pubDate: result.pubDate,
                artworkUrl: result.artworkURL,
                urlToShare: result.link,
                favorite: false,
                favoriteAction: {}
            )

            Button {
                onSelectLink(result.link)
            } label: {
                GlassCardView(data: cardContent)
            }
            .accessibilityLabel("Podcast: \(result.title)")
            .accessibilityHint("Duplo toque para abrir no navegador.")
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    func videoCard(for result: SearchResult) -> some View {
        let videoDB = result.videoDB
        let cardContent = CardContent(
            type: .video(
                views: "",
                likes: "",
                duration: result.duration ?? ""
            ),
            analytics: analytics,
            title: result.title,
            pubDate: result.pubDate,
            artworkUrl: result.artworkURL,
            urlToShare: result.link,
            favorite: result.favorite,
            favoriteAction: {
                guard let videoDB else { return }
                videoDB.favorite.toggle()
                videoDB.modifiedAt = Date()
                try? modelContext.save()
            }
        )

        Button {
            if let videoDB {
                onSelectVideo(videoDB)
            } else {
                onSelectLink(result.link)
            }
        } label: {
            GlassCardView(data: cardContent)
        }
        .accessibilityLabel("Video: \(result.title)")
        .accessibilityHint("Duplo toque para assistir.")
        .padding(.horizontal)
    }
}
