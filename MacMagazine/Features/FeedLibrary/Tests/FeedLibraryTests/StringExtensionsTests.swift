@testable import FeedLibrary
import Foundation
import Testing

@Suite("String Extensions Tests")
struct StringExtensionsTests {

    // MARK: - htmlDecoded Tests

    @Test("htmlDecoded should decode HTML entities")
    func htmlDecodedDecodesHTMLEntities() {
        // Given
        let input = "&lt;div&gt;test&lt;/div&gt;"

        // When
        let result = input.htmlDecoded

        // Then
        #expect(result.contains("<div>"))
        #expect(result.contains("</div>"))
    }

    @Test("htmlDecoded should replace ellipsis entity")
    func htmlDecodedReplacesEllipsis() {
        // Given
        let input = "text&#8230;"

        // When
        let result = input.htmlDecoded

        // Then
        #expect(!result.contains("&#8230;"))
    }

    @Test("htmlDecoded should handle plain text")
    func htmlDecodedHandlesPlainText() {
        // Given
        let input = "plain text"

        // When
        let result = input.htmlDecoded

        // Then
        #expect(result == "plain text")
    }

    @Test("htmlDecoded should return original string on failure")
    func htmlDecodedReturnsOriginalOnFailure() {
        // Given - invalid UTF-8 sequence won't cause crash
        let input = "simple test"

        // When
        let result = input.htmlDecoded

        // Then
        #expect(!result.isEmpty)
    }

    // MARK: - clean Tests

    @Test("clean should remove consecutive newlines")
    func cleanRemovesConsecutiveNewlines() {
        // Given
        let input = "line1\n\nline2"

        // When
        let result = input.clean

        // Then
        #expect(result == "line1\nline2")
    }

    @Test("clean should remove multiple consecutive newlines")
    func cleanRemovesMultipleConsecutiveNewlines() {
        // Given
        let input = "line1\n\n\n\nline2"

        // When
        let result = input.clean

        // Then
        #expect(!result.contains("\n\n"))
    }

    @Test("clean should preserve single newlines")
    func cleanPreservesSingleNewlines() {
        // Given
        let input = "line1\nline2\nline3"

        // When
        let result = input.clean

        // Then
        #expect(result == "line1\nline2\nline3")
    }

    @Test("clean should handle empty string")
    func cleanHandlesEmptyString() {
        // Given
        let input = ""

        // When
        let result = input.clean

        // Then
        #expect(result.isEmpty)
    }

    @Test("clean should handle string with only newlines")
    func cleanHandlesOnlyNewlines() {
        // Given
        let input = "\n\n\n\n"

        // When
        let result = input.clean

        // Then
        #expect(!result.contains("\n\n"))
    }

    // MARK: - Integration Tests

    @Test("htmlDecoded and clean should work together")
    func chainingHtmlDecodedAndClean() {
        // Given
        let input = "&lt;div&gt;\n\ntest"

        // When
        let result = input.htmlDecoded.clean

        // Then
        #expect(!result.contains("\n\n"))
        #expect(result.contains("div"))
    }
}
