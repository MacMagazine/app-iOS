import Foundation
@testable import MacMagazineUILibrary
import SwiftUI
import Testing

@Suite("DisqusHTMLBuilder Tests")
struct DisqusHTMLBuilderTests {

    // MARK: - pageURL

    @Test("Should serve the comments page from a secure disqus.com origin so login cookies are first-party")
    func pageURLIsSameSiteAsDisqus() throws {
        // Given
        let url = try #require(DisqusHTMLBuilder.pageURL)

        // Then
        #expect(url.scheme == "https")
        #expect(url.host() == "\(DisqusHTMLBuilder.shortname).disqus.com")
    }

    @Test("Should not fall back to an opaque about:blank origin")
    func pageURLIsNotAboutBlank() throws {
        // Given
        let url = try #require(DisqusHTMLBuilder.pageURL)

        // Then
        #expect(url.absoluteString != "about:blank")
    }

    // MARK: - makeHTML

    @Test("Should load the embed script from the same forum as the page origin", arguments: [ColorScheme.light, .dark])
    func embedScriptMatchesForum(colorScheme: ColorScheme) {
        // When
        let html = DisqusHTMLBuilder.makeHTML(commentsURL: "https://macmagazine.com.br/post", colorScheme: colorScheme)

        // Then
        #expect(html.contains("var disqus_shortname = '\(DisqusHTMLBuilder.shortname)';"))
        #expect(html.contains("var disqus_identifier = 'https://macmagazine.com.br/post';"))
    }

    @Test("Should keep the identifier empty when no comments URL is given")
    func emptyCommentsURL() {
        // When
        let html = DisqusHTMLBuilder.makeHTML(commentsURL: "", colorScheme: .light)

        // Then
        #expect(html.contains("var disqus_identifier = '';"))
    }
}
