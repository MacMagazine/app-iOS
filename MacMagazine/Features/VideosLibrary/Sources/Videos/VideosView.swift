import AnalyticsLibrary
import MacMagazineLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary
import YouTubeLibrary

public struct VideosView: View {
    @Environment(SessionState.self) private var sessionState
    @EnvironmentObject private var analytics: AnalyticsManager
    var viewModel: VideosViewModel
    @State private var search: String = ""
    @Binding private var favorite: Bool
    @Binding var scrollPosition: ScrollPosition

    public init(
        storage: Database,
        favorite: Binding<Bool>,
        scrollPosition: Binding<ScrollPosition>
    ) {
        self.viewModel = VideosViewModel(storage: storage)
        _favorite = favorite
        _scrollPosition = scrollPosition
    }

    public var body: some View {
        Videos(
            card: AdaptiveVideoCard(
                context: viewModel.context,
                analytics: analytics
            ),
            api: viewModel.youtube,
            scrollPosition: $scrollPosition,
            favorite: favorite,
            search: search
        )
        .onAppear {
            viewModel.youtube.update(hasFetchedVideos: Binding(
                get: { sessionState.hasFetchedVideos },
                set: { value in sessionState.hasFetchedVideos = value }
            ))

            if sessionState.isPlayingPodcasts {
                viewModel.youtube.selectedVideo = nil
                sessionState.isPlayingPodcasts = false
            }
        }
        .onChange(of: viewModel.youtube.selectedVideo) { _, value in
            sessionState.isPlayingVideos = (value != nil)
            if let value {
                analytics.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.videoStarted(id: value.videoId).id,
                    screen: AnalyticsConstants.Screen.videos.name
                ))
            } else {
                analytics.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.videoStopped.id,
                    screen: AnalyticsConstants.Screen.videos.name
                ))
            }
        }
        .onChange(of: sessionState.isPlayingPodcasts) { _, value in
            if value {
                viewModel.youtube.selectedVideo = nil
            }
        }
    }
}

#Preview {
    let storage = Database(models: [VideoDB.self], inMemory: true)
    VideosView(
        storage: storage,
        favorite: .constant(false),
        scrollPosition: .constant(.init())
    )
    .environment(\.theme, ThemeColor())
}
