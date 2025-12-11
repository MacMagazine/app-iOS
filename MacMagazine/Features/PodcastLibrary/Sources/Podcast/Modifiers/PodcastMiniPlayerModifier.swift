import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public struct PodcastMiniPlayerModifier: ViewModifier {
    @Environment(PodcastPlayerManager.self) private var manager
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar
    @Namespace private var animation

    private let isAllowedToShow: () -> Bool

    public init(
        isAllowedToShow: @escaping () -> Bool
    ) {
        self.isAllowedToShow = isAllowedToShow
    }

    public func body(content: Content) -> some View {
        let hasPodcast       = manager.currentPodcast != nil
        let canShowInContext = isAllowedToShow()
        let shouldShowMini   = hasPodcast && canShowInContext

        return Group {
            if shouldShowMini {
                if shouldUseSidebar {
                    content
                        .safeAreaInset(edge: .bottom, spacing: 16) {
                            if let current = manager.currentPodcast {
                                MediumPlayerView(
                                    playerManager: manager,
                                    currentPodcast: current
                                )
                                .frame(maxWidth: 550)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.horizontal, 20)
                            }
                        }
                } else {
                    content
                        .tabBarMinimizeBehavior(.onScrollDown)
                        .tabViewBottomAccessory {
                            if let current = manager.currentPodcast {
                                MiniPlayerView(
                                    playerManager: manager,
                                    currentPodcast: current
                                )
                                .matchedTransitionSource(id: "MINIPLAYER", in: animation)
                                .padding(.horizontal, 8)
                            }
                        }
                }
            } else {
                content
            }
        }
    }
}

public extension View {
    func podcastMiniPlayer(
        isAllowedToShow: @escaping () -> Bool = { true }
    ) -> some View {
        self.modifier(
            PodcastMiniPlayerModifier(
                isAllowedToShow: isAllowedToShow
            )
        )
    }
}
