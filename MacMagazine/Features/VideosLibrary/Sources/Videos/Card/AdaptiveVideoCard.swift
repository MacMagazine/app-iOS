import MacMagazineLibrary
import SwiftUI
import YouTubeLibrary

@MainActor
public struct AdaptiveVideoCard: VideoCard {
    public var accessibilityLabels: [CardLabel]?
    public var accessibilityButtons: [CardButton]?

    public init() {}

    public func makeBody(data: VideoDB) -> some View {
        AdaptiveBody(data: data)
    }

    private struct AdaptiveBody: View {
        @Environment(\.theme) private var theme: ThemeColor
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize

        let data: VideoDB

        var body: some View {
            Group {
                if dynamicTypeSize < .accessibility1 {
                    GlassCardView(data: data)
                } else {
                    ClassicCard(buttonColor: theme.text.primary.color).makeBody(data: data)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    @MainActor
    struct MMVideoDBPreview {
        static let sample = VideoDB(
            artworkURL: "https://i.ytimg.com/vi/bq02LMjcCns/maxresdefault.jpg",
            current: 42.0,
            duration: "PT4M46S".formattedYTDuration,
            favorite: true,
            likes: "782",
            pubDate: "2021-02-17T20:45:21Z",
            title: "Como Usar WhatsApp No iPad",
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
