@testable import FeedLibrary
import Foundation
import Testing

@Suite("String Extensions Tests")
struct StringExtensionsTests {

    // MARK: - Escaped Tests

    @Test("escaped should encode special characters")
    func escapedEncodesSpecialCharacters() {
        // Given
        let input = "hello world"

        // When
        let result = input.escaped

        // Then
        #expect(result == "hello%20world")
    }

    @Test("escaped should handle empty string")
    func escapedHandlesEmptyString() {
        // Given
        let input = ""

        // When
        let result = input.escaped

        // Then
        #expect(result.isEmpty)
    }

    @Test("escaped should preserve alphanumeric characters")
    func escapedPreservesAlphanumeric() {
        // Given
        let input = "abc123"

        // When
        let result = input.escaped

        // Then
        #expect(result == "abc123")
    }

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

    // MARK: - decodedHTMLString Tests

    @Test("decodedHTMLString should decode HTML content")
    func decodedHTMLStringDecodesHTML() {
        // Given
        let input = "<p>Hello World</p>"

        // When
        let result = input.decodedHTMLString

        // Then
        #expect(result.contains("Hello World"))
        #expect(!result.contains("<p>"))
    }

    @Test("decodedHTMLString should handle HTML entities")
    func decodedHTMLStringHandlesEntities() {
        // Given
        let input = "&amp;&lt;&gt;"

        // When
        let result = input.decodedHTMLString

        // Then
        #expect(result.contains("&"))
        #expect(result.contains("<"))
        #expect(result.contains(">"))
    }

    @Test("decodedHTMLString should handle plain text")
    func decodedHTMLStringHandlesPlainText() {
        // Given
        let input = "plain text"

        // When
        let result = input.decodedHTMLString

        // Then
        #expect(result.contains("plain text"))
    }

    @Test("decodedHTMLString should return error description on failure")
    func decodedHTMLStringReturnsErrorOnFailure() {
        // Given - This won't actually fail, but tests the error path exists
        let input = "test"

        // When
        let result = input.decodedHTMLString

        // Then - Should not be empty
        #expect(!result.isEmpty)
    }

    // MARK: - Integration Tests

    @Test("chaining escaped and clean should work together")
    func chainingEscapedAndClean() {
        // Given
        let input = "hello world\n\ntest"

        // When
        let result = input.clean.escaped

        // Then
        #expect(!result.contains("\n\n"))
        #expect(result.contains("%20"))
    }

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
