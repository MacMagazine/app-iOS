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

    private func unescapeHTMLEntities(in string: String) -> String {
        let cfStr: CFString = string as CFString
        if let unescaped = CFXMLCreateStringByUnescapingEntities(kCFAllocatorDefault, cfStr, nil) {
            return unescaped as String
        }
        return string
    }
}
