import FeedLibrary
import StorageLibrary
import SwiftUI
import WidgetKit

@MainActor
struct MacMagazineTimelineProvider: TimelineProvider {
    let viewModel = FeedViewModel(
        storage: Database(models: [], inMemory: true)
    )

    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), posts: [.placeholder, .placeholder, .placeholder])
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        let family = context.family
        let displaySize = context.displaySize
        Task {
            let content = await getWidgetContent(family: family, displaySize: displaySize)
            completion(WidgetEntry(date: Date(), posts: content.posts))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        let family = context.family
        let displaySize = context.displaySize
        Task {
            let content = await getWidgetContent(family: family, displaySize: displaySize)
            let now = Date()
            let nextUpdate = WidgetRefreshSchedule.nextRefresh(after: now, succeeded: content.succeeded)
            let timeline = Timeline(entries: [WidgetEntry(date: now, posts: content.posts)], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}

private extension MacMagazineTimelineProvider {
    static let feedDeadline: Duration = .seconds(15)
    static let imageTimeout: TimeInterval = 10
    static let pixelScale: CGFloat = 3

    func getWidgetContent(family: WidgetFamily, displaySize: CGSize) async -> (posts: [WidgetData], succeeded: Bool) {
        let cache = WidgetPostsCache(fileURL: URL.cachesDirectory.appending(path: "widget-posts-\(family.description).json"))

        let fetchedData = await fetchWithDeadline()
        guard !fetchedData.isEmpty else {
            return (cache.load(), false)
        }

        let posts = await withImages(
            fetchedData,
            count: imageCount(for: family),
            targetPixelSize: targetPixelSize(for: family, displaySize: displaySize)
        )
        try? cache.save(posts)
        return (posts, true)
    }

    func fetchWithDeadline() async -> [WidgetData] {
        await withTaskGroup(of: [WidgetData]?.self) { group in
            group.addTask { @MainActor in
                try? await viewModel.getWidgetData()
            }
            group.addTask {
                try? await Task.sleep(for: Self.feedDeadline)
                return nil
            }
            let first = await group.next()
            group.cancelAll()
            return first.flatMap { $0 } ?? []
        }
    }

    func withImages(_ posts: [WidgetData], count: Int, targetPixelSize: Int) async -> [WidgetData] {
        let images = await withTaskGroup(of: (Int, Data?).self) { group in
            for (index, post) in posts.prefix(count).enumerated() {
                let thumbnail = post.thumbnail
                group.addTask {
                    (index, await Self.downscaledImage(from: thumbnail, targetPixelSize: targetPixelSize))
                }
            }
            var images = [Int: Data]()
            for await (index, data) in group {
                images[index] = data
            }
            return images
        }

        return posts.enumerated().map { index, data in
            WidgetData(
                postId: data.postId,
                title: data.title,
                thumbnail: data.thumbnail,
                pubDate: data.pubDate,
                link: data.link,
                imageData: images[index]
            )
        }
    }

    nonisolated static func downscaledImage(from thumbnail: String, targetPixelSize: Int) async -> Data? {
        guard let thumbnailUrl = URL(string: thumbnail) else { return nil }
        let request = URLRequest(url: thumbnailUrl, timeoutInterval: imageTimeout)
        guard let (image, _) = try? await URLSession.shared.data(for: request) else { return nil }
        return WidgetImageDownscaler.downscale(image, targetPixelSize: targetPixelSize)
    }

    func imageCount(for family: WidgetFamily) -> Int {
        switch family {
        case .systemSmall, .accessoryRectangular, .accessoryInline: 1
        case .systemMedium: 2
        case .systemLarge: 3
        default: 1
        }
    }

    func targetPixelSize(for family: WidgetFamily, displaySize: CGSize) -> Int {
        switch family {
        case .systemMedium: Int(40 * Self.pixelScale)
        case .systemLarge: Int(60 * Self.pixelScale)
        default: Int(max(displaySize.width, displaySize.height) * Self.pixelScale)
        }
    }
}
