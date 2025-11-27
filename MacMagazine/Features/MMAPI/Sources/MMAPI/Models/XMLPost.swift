//
//  XMLPost.swift
//  MMAPI
//
//  Created by Luis Amorim on 27/11/25.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct XMLPost: Hashable {
    public var title = ""
    public var link = ""
    public var pubDate = ""
    public var categories: [String] = []
    public var excerpt = ""
    public var artworkURL = ""
    public var podcastURL = ""
    public var podcast = ""
    public var duration = ""
    public var podcastFrame = ""
    public var favorite = false
    public var postId = ""
    public var shortURL = ""
    public var playable = false
    public var fullContent = ""

    public init() {}

    public func decodedHTML(_ string: String) -> String {
        #if canImport(UIKit) || canImport(AppKit)
        if let data = string.data(using: .utf8) {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            if let attributed = try? NSAttributedString(
                data: data,
                options: options,
                documentAttributes: nil
            ) {
                return attributed.string
            }
        }
        #endif
        return unescapeHTMLEntities(in: string)
    }

    // Fallback HTML entity unescape without using deprecated CFXML APIs.
    // Supports common named entities and numeric (decimal/hex) references.
    private func unescapeHTMLEntities(in string: String) -> String {
        if string.isEmpty { return string }

        // First handle numeric entities: &#...; and &#x...;
        let result = string.replacingOccurrences(of: #"&#(x?[0-9A-Fa-f]+);"#, with: { match in
            let body = match[1]
            if body.hasPrefix("x") || body.hasPrefix("X") {
                let hex = String(body.dropFirst())
                if let value = UInt32(hex, radix: 16), let scalar = UnicodeScalar(value) {
                    return String(scalar)
                }
            } else {
                if let value = UInt32(body, radix: 10), let scalar = UnicodeScalar(value) {
                    return String(scalar)
                }
            }
            return match[0] // return original if parsing fails
        })

        // Then handle a small set of common named entities
        // Extend this map if you need more.
        let entities: [String: String] = [
            "amp": "&",
            "lt": "<",
            "gt": ">",
            "quot": "\"",
            "apos": "'",
            "nbsp": "\u{00A0}"
        ]

        var output = result
        for (name, value) in entities {
            output = output.replacingOccurrences(of: "&\(name);", with: value)
        }
        return output
    }
}

// MARK: - Lightweight regex replace helper using NSRegularExpression
private extension String {
    func replacingOccurrences(of pattern: String, with transform: ([String]) -> String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return self
        }
        let nsString = self as NSString
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))

        // Build result by walking from end to start to keep ranges valid
        var result = self
        for match in matches.reversed() {
            var groups: [String] = []
            for i in 0..<match.numberOfRanges {
                let range = match.range(at: i)
                if range.location != NSNotFound, let swiftRange = Range(range, in: result) {
                    groups.append(String(result[swiftRange]))
                } else {
                    groups.append("")
                }
            }
            let replacement = transform(groups)
            if let swiftRange = Range(match.range, in: result) {
                result.replaceSubrange(swiftRange, with: replacement)
            }
        }
        return result
    }
}
