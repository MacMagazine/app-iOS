import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
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
        let grouped = Dictionary(grouping: results, by: \.type)

        if let newsResults = grouped[.news] {
            section(title: "Notícias", results: newsResults)
        }
        if let podcastResults = grouped[.podcast] {
            section(title: "Podcasts", results: podcastResults)
        }
        if let videoResults = grouped[.video] {
            section(title: "Vídeos", results: videoResults)
        }
    }
}

// MARK: - Sections

private extension SearchResultsList {

    @ViewBuilder
    func section(title: String, results: [SearchResult]) -> some View {
        Section {
            ForEach(results) { result in
                resultCard(for: result)
            }
        } header: {
            Text(title)
                .font(.title3.bold())
                .padding(.horizontal)
                .padding(.top, 8)
        }
    }

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
        let cardContent = CardContent(
            type: .news(
                categories: result.categories.compactMap { categoryName in
                    NewsCategory.allCases.first { $0.filterKey == categoryName }
                },
                style: .glass
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

        Button {
            if let feedDB {
                onSelectNews(feedDB)
            } else {
                onSelectLink(result.link)
            }
        } label: {
            GlassCardView(data: cardContent)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    func podcastCard(for result: SearchResult) -> some View {
        let podcastDB = result.podcastDB
        let cardContent = CardContent(
            type: .podcast(duration: result.duration ?? ""),
            analytics: analytics,
            title: result.title,
            pubDate: result.pubDate,
            artworkUrl: result.artworkURL,
            urlToShare: result.link,
            favorite: result.favorite,
            favoriteAction: {
                guard let podcastDB else { return }
                podcastDB.favorite.toggle()
                podcastDB.modifiedAt = Date()
                try? modelContext.save()
            }
        )

        Button {
            if let podcastDB {
                onSelectPodcast(podcastDB)
            } else {
                onSelectLink(result.link)
            }
        } label: {
            GlassCardView(data: cardContent)
        }
        .padding(.horizontal)
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
        .padding(.horizontal)
    }
}
