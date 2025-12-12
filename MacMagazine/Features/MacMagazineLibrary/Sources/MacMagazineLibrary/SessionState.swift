import Foundation

@Observable
public class SessionState {
    // Social content
    public var hasFetchedPodcasts = false
    public var hasFetchedVideos = false

    // Feed content
    public var hasFetchedFeed = false

    public init() {}

    public func reset() {
        hasFetchedPodcasts = false
        hasFetchedVideos = false
        hasFetchedFeed = false
    }
}
