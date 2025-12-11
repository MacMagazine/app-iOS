import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public struct PodcastMiniPlayerModifier: ViewModifier {
    @Environment(PodcastPlayerManager.self) private var manager
    @Namespace private var animation

    @State private var showFullPlayer = false

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

        let base = content
            .fullScreenCover(isPresented: $showFullPlayer) {
                PodcastFullScreenView(
                    manager: manager,
                    animation: animation,
                    onDismiss: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            showFullPlayer = false
                        }
                    }
                )
            }
            .onChange(of: manager.currentPodcast?.id) { _, newID in
                if newID == nil {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                        showFullPlayer = false
                    }
                }
            }

        return Group {
            if shouldShowMini {
                base
                    .tabBarMinimizeBehavior(.onScrollDown)
                    .tabViewBottomAccessory {
                        if let current = manager.currentPodcast {
                            MiniPlayerView(
                                playerManager: manager,
                                currentPodcast: current
                            ) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                    showFullPlayer = true
                                }
                            }
                            .matchedTransitionSource(id: "MINIPLAYER", in: animation)
                            .padding(.horizontal, 8)
                        }
                    }
            } else {
                base   // sem accessory, sem espaço sobrando
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
