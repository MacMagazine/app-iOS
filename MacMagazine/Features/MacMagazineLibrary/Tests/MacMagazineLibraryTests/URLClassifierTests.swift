import Foundation
@testable import MacMagazineLibrary
import Testing

// swiftlint:disable force_unwrapping
@Suite("URLClassifier Tests")
struct URLClassifierTests {

    @Test("Comments scheme returns .comments with slug")
    func commentsScheme() {
        let url = URL(string: "comments://Post%20Title")!
        #expect(URLClassifier.classify(url) == .comments("Post Title"))
    }

    @Test("Disqus anchor returns .comments")
    func disqusAnchor() {
        let url = URL(string: "https://macmagazine.com.br/post/123#disqus_thread")!
        #expect(URLClassifier.classify(url) == .comments("https://macmagazine.com.br/post/123"))
    }

    @Test("Instagram URL returns .instagram")
    func instagram() {
        let url = URL(string: "https://www.instagram.com/macmagazine")!
        #expect(URLClassifier.classify(url) == .instagram)
    }

    @Test("App Store URL returns .appStore")
    func appStore() {
        let url = URL(string: "https://apps.apple.com/br/app/macmagazine/id1234")!
        #expect(URLClassifier.classify(url) == .appStore)
    }

    @Test("iTunes URL returns .appStore")
    func iTunes() {
        let url = URL(string: "https://itunes.apple.com/app/id123")!
        #expect(URLClassifier.classify(url) == .appStore)
    }

    @Test("YouTube URL returns .youTube")
    func youTube() {
        let url = URL(string: "https://www.youtube.com/watch?v=abc")!
        #expect(URLClassifier.classify(url) == .youTube)
    }

    @Test("Short YouTube URL returns .youTube")
    func youTuBe() {
        let url = URL(string: "https://youtu.be/abc")!
        #expect(URLClassifier.classify(url) == .youTube)
    }

    @Test("MacMagazine URL returns .macmagazinePost")
    func macmagazinePost() {
        let url = URL(string: "https://macmagazine.com.br/post/2026/03/06/article")!
        #expect(URLClassifier.classify(url) == .macmagazinePost)
    }

    @Test("Generic URL returns .external")
    func external() {
        let url = URL(string: "https://www.google.com")!
        #expect(URLClassifier.classify(url) == .external)
    }

    @Test("pkpass URL returns .walletPass")
    func walletPass() {
        let url = URL(string: "https://macmagazine.com.br/wp-content/uploads/2026/06/wwdc26.pkpass")!
        #expect(URLClassifier.classify(url) == .walletPass)
    }

    @Test("pkpass URL is classified before the macmagazine host check")
    func walletPassTakesPrecedenceOverHost() {
        let url = URL(string: "https://macmagazine.com.br/passes/keynote.PKPASS")!
        #expect(URLClassifier.classify(url) == .walletPass)
    }
}
// swiftlint:enable force_unwrapping
