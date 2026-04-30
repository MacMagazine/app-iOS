import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import NewsLibrary
import PodcastLibrary
import SwiftData
import SwiftUI
import VideosLibrary
import YouTubeLibrary

struct SearchResultsList: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var analytics: AnalyticsManager

    let results: [SearchResult]
    let onSelectNews: (FeedDB) -> Void
    let onSelectPodcast: (PodcastDB) -> Void
    @Binding var selectedVideo: VideoDB?
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
        if let feedDB = result.feedDB {
            let cardContent = feedDB.toCardContent(
                using: modelContext,
                analytics: analytics,
                screen: nil,
                style: feedDB.categories.toNewsCategory.mostRelevant.style
            )

            NewsCard(data: cardContent) {
                onSelectNews(feedDB)
            }
            .cardAccessibility(
                data: cardContent,
                labels: [NewsLibrary.CardLabel.title, NewsLibrary.CardLabel.date],
                buttons: [NewsLibrary.CardButton.favorite, NewsLibrary.CardButton.share]
            )
        }
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
        }
    }

    @ViewBuilder
    func videoCard(for result: SearchResult) -> some View {
        if let videoDB = result.videoDB {
            let card = AdaptiveVideoCard(
                context: modelContext,
                analytics: analytics
            )

            VideoItemView(card: card,
                          video: videoDB,
                          selectedVideo: $selectedVideo)
            .cardAccessibility(
                data: videoDB,
                labels: card.accessibilityLabels,
                buttons: card.accessibilityButtons
            )
        }
    }
}
