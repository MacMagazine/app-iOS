import AnalyticsLibrary
import FeedLibrary
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
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var analytics: AnalyticsManager
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
                            colorScheme: colorScheme
                        )
                        .frame(maxWidth: 480, alignment: .center)
                        .frame(height: 60)
                        .padding(.horizontal, 20)
                        .glassEffect(.regular)
                    }
                    .fullPlayerSheet(manager: manager, analytics: analytics)
            } else {
                content
                    .tabBarMinimizeBehavior(.onScrollDown)
                    .tabViewBottomAccessory {
                        MiniPlayerView(
                            playerManager: manager,
                            currentPodcast: current,
                            colorScheme: colorScheme
                        )
                        .matchedTransitionSource(id: "MINIPLAYER", in: animation)
                        .padding(.horizontal, 8)
                    }
                    .fullPlayerSheet(manager: manager, analytics: analytics)
            }
        } else {
            content
                .fullPlayerSheet(manager: manager, analytics: analytics)
        }
    }
}

private extension View {
    func fullPlayerSheet(manager: PodcastPlayerManager, analytics: AnalyticsManager) -> some View {
        self.sheet(
            isPresented: Binding(
                get: { manager.isFullscreen },
                set: { manager.isFullscreen = $0 }
            )
        ) {
            FullPlayerView(
                playerManager: manager,
                backgroundGradientStyle: .fourTone
            )
            .presentationDragIndicator(.visible)
            .environmentObject(analytics)
        }
    }
}
