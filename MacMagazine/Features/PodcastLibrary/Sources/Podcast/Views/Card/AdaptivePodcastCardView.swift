import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

public struct AdaptivePodcastCardView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    public let podcast: CardContent
    public let onPlay: () -> Void

    public init(podcast: CardContent, onPlay: @escaping () -> Void) {
        self.podcast = podcast
        self.onPlay = onPlay
    }

    public var body: some View {
        content
            .cardAccessibility(
                data: podcast,
                labels: [.title, .date, .duration],
                buttons: [.favorite, .share]
            )
    }

    @ViewBuilder
    private var content: some View {
        if dynamicTypeSize.usesPrimaryCardLayout {
            GlassPodcastCardView(
                podcast: podcast,
                onPlay: onPlay
            )
        } else {
            PodcastCardView(
                podcast: podcast,
                onPlay: onPlay
            )
        }
    }
}
