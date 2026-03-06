import MacMagazineLibrary
import SwiftUI
import WebKit

@MainActor
struct MMNavigationDecider: WebPage.NavigationDeciding {
    var onOpenComments: ((String) -> Void)?
    var onOpenInternalLink: ((URL) -> Void)?

    mutating func decidePolicy(
        for action: WebPage.NavigationAction,
        preferences: inout WebPage.NavigationPreferences
    ) async -> WKNavigationActionPolicy {
        guard let url = action.request.url else {
            return .allow
        }

        switch action.navigationType {
        case .linkActivated:
            switch URLClassifier.classify(url) {
            case let .comments(slug):
                onOpenComments?(slug)
            case .macmagazinePost:
                if let handler = onOpenInternalLink {
                    handler(url)
                } else {
                    open(url)
                }
            case .appStore, .youTube, .instagram, .external:
                open(url)
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
