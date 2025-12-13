import Foundation
import Combine

public class SessionState: ObservableObject {
    // Social content
    @Published public var hasFetchedPodcasts = false
    @Published public var hasFetchedVideos = false

    @Published public var isPlayingPodcasts = false
    @Published public var isPlayingVideos = false

    // Feed content
    @Published public var hasFetchedFeed = false

    public init() {}

    public func reset() {
        hasFetchedPodcasts = false
        hasFetchedVideos = false
        isPlayingPodcasts = false
        isPlayingVideos = false

        hasFetchedFeed = false
    }
}
