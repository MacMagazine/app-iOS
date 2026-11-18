import Foundation

/// Keeps the last successfully fetched widget posts on disk so a failed refresh doesn't blank the widget.
public struct WidgetPostsCache: Sendable {
    public let fileURL: URL

    public init(fileURL: URL) {
        self.fileURL = fileURL
    }

    /// Returns the cached posts, or an empty array when the file is missing or can't be decoded.
    public func load() -> [WidgetData] {
        guard let data = try? Data(contentsOf: fileURL),
              let posts = try? JSONDecoder().decode([WidgetData].self, from: data) else {
            return []
        }
        return posts
    }

    /// Overwrites the cache with `posts`. An empty array is ignored so the last good posts survive.
    public func save(_ posts: [WidgetData]) throws {
        guard !posts.isEmpty else { return }
        let data = try JSONEncoder().encode(posts)
        try data.write(to: fileURL, options: .atomic)
    }
}
