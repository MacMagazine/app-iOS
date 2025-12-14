import SwiftUI
import UIComponentsLibrary

struct BackgroundView: View {
    let chapter: PodcastChapter?
    let backgroundGradientColors: [Color]
    let usesGradient: Bool

    var body: some View {
        if usesGradient {
            gradientBackground
        } else {
            imageBackground
        }
    }
}

private extension BackgroundView {
    private var gradientBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: backgroundGradientColors),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var imageBackground: some View {
        GeometryReader { geo in
            PodcastImageView(
                artworkData: chapter?.artworkData,
                location: .background,
                fallback: { gradientBackground })
            .frame(width: geo.size.width)
            .ignoresSafeArea()
            .accessibilityHidden(true)
            .id(chapter?.id ?? UUID()) // Triggers animation when chapter changes
        }
    }
}
