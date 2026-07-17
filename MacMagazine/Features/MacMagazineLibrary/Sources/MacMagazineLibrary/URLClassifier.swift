import Foundation

public enum URLClassification: Equatable, Sendable {
    case comments(String)
    case walletPass
    case macmagazinePost
    case appStore
    case youTube
    case instagram
    case external
}

public enum URLClassifier {
    public static func classify(_ url: URL) -> URLClassification {
        // Comments scheme (comments://...)
        if url.scheme == "comments" {
            let slug = url.absoluteString
                .replacingOccurrences(of: "comments://", with: "")
                .replacingOccurrences(of: "%20", with: " ")
            return .comments(slug)
        }

        // Disqus anchor (#disqus_thread)
        if url.fragment == "disqus_thread" {
            let slug = url.absoluteString
                .replacingOccurrences(of: "#disqus_thread", with: "")
            return .comments(slug)
        }

        // Apple Wallet pass (e.g. event tickets), regardless of host
        if url.pathExtension.lowercased() == "pkpass" {
            return .walletPass
        }

        let host = url.host?.lowercased() ?? ""

        // Instagram
        if host.contains("instagram.com") {
            return .instagram
        }

        // App Store
        if host.contains("apps.apple.com") || host.contains("itunes.apple.com") {
            return .appStore
        }

        // YouTube
        if host.contains("youtube.com") || host.contains("youtu.be") {
            return .youTube
        }

        // Internal macmagazine link
        if host.contains("macmagazine.com.br") {
            return .macmagazinePost
        }

        return .external
    }
}
