import Foundation
@preconcurrency import WebKit

/// Shared persistent data store for all Disqus webviews so cookies are
/// preserved between the comments page and the login page.
@MainActor
enum DisqusDataStore {
    // swiftlint:disable:next force_unwrapping
    static let shared = WKWebsiteDataStore(forIdentifier: UUID(uuidString: "D15C0500-C00E-5700-BE00-0AC0A6A21E00")!)
}
