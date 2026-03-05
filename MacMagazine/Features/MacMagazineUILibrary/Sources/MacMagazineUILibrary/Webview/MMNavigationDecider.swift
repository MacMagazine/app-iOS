import SwiftUI
import WebKit

@MainActor
struct MMNavigationDecider: WebPage.NavigationDeciding {
    var onOpenComments: ((String) -> Void)?

    mutating func decidePolicy(
        for action: WebPage.NavigationAction,
        preferences: inout WebPage.NavigationPreferences
    ) async -> WKNavigationActionPolicy {
        guard let url = action.request.url else {
            return .allow
        }

        switch action.navigationType {
        case .linkActivated:
            if url.host?.lowercased().contains("instagram.com") ?? false {
                open(url)
            } else if url.absoluteString.contains("comments://") {
                let commentsURL = url.absoluteString
                    .replacingOccurrences(of: "comments://", with: "")
                    .replacingOccurrences(of: "%20", with: " ")
                onOpenComments?(commentsURL)
            }
            return .cancel

        default:
            return .allow
        }
    }

    private func open(_ url: URL) {
#if canImport(UIKit)
        UIApplication.shared.open(url)
#endif
    }
}
