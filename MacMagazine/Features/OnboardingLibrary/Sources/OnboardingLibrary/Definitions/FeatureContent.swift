import Foundation

public struct FeatureContent: Identifiable {
    public let id: Int
    public let title: String
    public let description: String
    public let systemImage: String

    public init(id: Int, title: String, description: String, systemImage: String) {
        self.id = id
        self.title = title
        self.description = description
        self.systemImage = systemImage
    }

    public nonisolated(unsafe) static let allFeatures: [FeatureContent] = [
        FeatureContent(
            id: 1,
            title: "All new UI",
            description: "Liquid Glass. Fast, easy to use.",
            systemImage: "sparkles"
        ),
        FeatureContent(
            id: 2,
            title: "iPhone and iPad",
            description: "Different experience designed for each device.",
            systemImage: "iphone.and.ipad"
        ),
        FeatureContent(
            id: 3,
            title: "Podcast experience",
            description: "Full player control. Chapters.",
            systemImage: "podcast.fill"
        ),
        FeatureContent(
            id: 4,
            title: "Instagram",
            description: "New Instagram category.",
            systemImage: "photo.on.rectangle.angled"
        ),
        FeatureContent(
            id: 5,
            title: "Posts categories",
            description: "Browse content organized by categories.",
            systemImage: "folder.fill"
        ),
        FeatureContent(
            id: 6,
            title: "Customisable App",
            description: "Make it yours with personalized settings.",
            systemImage: "slider.horizontal.3"
        ),
        FeatureContent(
            id: 7,
            title: "iCloud sync",
            description: "Your preferences sync across all devices.",
            systemImage: "icloud.fill"
        ),
        FeatureContent(
            id: 8,
            title: "New Watch App",
            description: "Stay informed on your wrist.",
            systemImage: "applewatch"
        ),
        FeatureContent(
            id: 9,
            title: "New Widgets UI",
            description: "Beautiful widgets with Liquid Glass design.",
            systemImage: "square.grid.2x2.fill"
        ),
        FeatureContent(
            id: 10,
            title: "One more thing",
            description: "Discover hidden features throughout the app.",
            systemImage: "gift.fill"
        ),
        FeatureContent(
            id: 11,
            title: "macOS App",
            description: "Full-featured Mac app for desktop experience.",
            systemImage: "desktopcomputer"
        )
    ]
}
