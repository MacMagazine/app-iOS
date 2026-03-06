import Foundation
import Observation

@MainActor
@Observable
public class SessionState {
    public var hasFetchedPodcasts = false
    public var hasFetchedVideos = false

    public var isPlayingPodcasts = false
    public var isPlayingVideos = false

    public var notPlaying: Bool { !isPlayingPodcasts && !isPlayingVideos }

    public var hasFetchedFeed = false

    public init() {}

    public func reset() {
        hasFetchedPodcasts = false
        hasFetchedVideos = false
        isPlayingPodcasts = false
        isPlayingVideos = false

        hasFetchedFeed = false
    }
}
