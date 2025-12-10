import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

struct AdaptivePodcastCardView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let podcast: CardContent
    let onPlay: () -> Void

    var body: some View {
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
