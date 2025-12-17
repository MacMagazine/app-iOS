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
    @Environment(\.colorScheme) private var appColorScheme
    @Namespace private var animation

    public init() {}

    public func body(content: Content) -> some View {
        if let current = manager.currentPodcast {
            if shouldUseSidebar {
                content
                    .safeAreaInset(edge: .bottom, spacing: 16) {
                        MiniPlayerView(
                            playerManager: manager,
                            currentPodcast: current,
                            appColorScheme: appColorScheme
                        )
                        .frame(maxWidth: 480, alignment: .center)
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
                            currentPodcast: current,
                            appColorScheme: appColorScheme
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
