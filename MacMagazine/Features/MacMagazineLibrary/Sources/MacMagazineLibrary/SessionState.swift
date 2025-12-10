import Foundation

@Observable
public class SessionState {
    // Social content
    public var hasFetchedPodcasts = false
    public var hasFetchedVideos = false
    public var hasFetchedInstagram = false

    // News content
    public var hasFetchedPosts = false

    public init() {}

    public func reset() {
        hasFetchedPodcasts = false
        hasFetchedVideos = false
        hasFetchedInstagram = false
        hasFetchedPosts = false
    }
}
