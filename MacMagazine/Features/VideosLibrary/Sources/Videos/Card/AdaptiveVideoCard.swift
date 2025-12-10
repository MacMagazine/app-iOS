import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftData
import SwiftUI
import YouTubeLibrary

@MainActor
public struct AdaptiveVideoCard: VideoCard {
    public var accessibilityLabels: [CardLabel]?
    public var accessibilityButtons: [CardButton]?

    var context: ModelContext?

    public init() {}

    init(context: ModelContext) {
        self.context = context
    }

    public func makeBody(data: VideoDB) -> some View {
        AdaptiveBody(data: data, context: context)
    }

    private struct AdaptiveBody: View {
        @Environment(\.theme) private var theme: ThemeColor
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize

        let data: VideoDB
        let context: ModelContext?

        var body: some View {
            if dynamicTypeSize.usesPrimaryCardLayout {
                GlassCardView(data: data.toCardContent(using: context))
            } else {
                ClassicCard(buttonColor: theme.text.primary.color).makeBody(data: data)
            }
        }
    }
}

#if DEBUG
#Preview {
    @MainActor
    struct MMVideoDBPreview {
        static let sample = VideoDB(
            artworkURL: "https://i.ytimg.com/vi/5rKJeiG-Rug/sddefault.jpg",
            current: 42.0,
            duration: "PT4M46S".formattedYTDuration,
            favorite: true,
            likes: "782",
            pubDate: "2021-02-17T20:45:21Z",
            title: "Apresento-lhes o… iPhone Pocket?!",
            videoId: "VVVBel9Fc3prM1lqcVZMdzZvWGJTS1FBLmJxMDJMTWpjQ25z",
            views: "5663"
        )
    }

    return ZStack {
        Color.brown.ignoresSafeArea()
        VStack(spacing: 30) {
            AdaptiveVideoCard().makeBody(data: MMVideoDBPreview.sample)
            .padding()
        }
    }
}
#endif
