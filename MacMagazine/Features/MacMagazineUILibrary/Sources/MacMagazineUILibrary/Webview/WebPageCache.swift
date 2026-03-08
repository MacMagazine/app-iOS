import WebKit

@MainActor
final class WebPageCache {
    static let shared = WebPageCache()

    private var cache: [String: WebPage] = [:]

    private init() {}

    func page(for key: String, configurationProvider: () -> WebPage.Configuration) -> WebPage {
        if let existing = cache[key] {
            return existing
        }
        let page = WebPage(configuration: configurationProvider())
        cache[key] = page
        return page
    }

    func page(
        for key: String,
        configurationProvider: () -> WebPage.Configuration,
        navigationDecider: some WebPage.NavigationDeciding
    ) -> WebPage {
        if let existing = cache[key] {
            return existing
        }
        let page = WebPage(
            configuration: configurationProvider(),
            navigationDecider: navigationDecider
        )
        cache[key] = page
        return page
    }

    func hasPage(for key: String) -> Bool {
        cache[key] != nil
    }

}
