import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public extension View {
    func podcastMiniPlayer() -> some View {
        self.modifier(PodcastMiniPlayerModifier())
    }
}

private struct PodcastMiniPlayerModifier: ViewModifier {
    @Environment(PodcastPlayerManager.self) private var manager
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar
    @Namespace private var animation

    public init() {}

    public func body(content: Content) -> some View {
        if let current = manager.currentPodcast {
            if shouldUseSidebar {
                content
                    .safeAreaInset(edge: .bottom, spacing: 16) {
                        MiniPlayerView(
                            playerManager: manager,
                            currentPodcast: current
                        )
                        .frame(maxWidth: 500, alignment: .center)
                        .frame(height: 60)
                        .padding(.horizontal, 20)
                        .glassEffect(.regular)
                    }
            } else {
                content
                    .tabBarMinimizeBehavior(.onScrollDown)
                    .tabViewBottomAccessory {
                        MiniPlayerView(
                            playerManager: manager,
                            currentPodcast: current
                        )
                        .matchedTransitionSource(id: "MINIPLAYER", in: animation)
                        .padding(.horizontal, 8)
                    }
            }
        } else {
            content
        }
    }
}
