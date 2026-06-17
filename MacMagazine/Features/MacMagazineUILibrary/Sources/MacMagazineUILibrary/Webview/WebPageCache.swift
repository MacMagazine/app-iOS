import WebKit

@MainActor
final class WebPageCache {
    static let shared = WebPageCache()

    private var cache: [String: WebPage] = [:]
    private var galleryHandlers: [String: GalleryStateMessageHandler] = [:]

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
        navigationDecider: some WebPage.NavigationDeciding,
        galleryStateHandler: GalleryStateMessageHandler
    ) -> WebPage {
        if let existing = cache[key] {
            return existing
        }
        let page = WebPage(
            configuration: configurationProvider(),
            navigationDecider: navigationDecider
        )
        cache[key] = page
        galleryHandlers[key] = galleryStateHandler
        return page
    }

    func galleryHandler(for key: String) -> GalleryStateMessageHandler? {
        galleryHandlers[key]
    }

    func hasPage(for key: String) -> Bool {
        cache[key] != nil
    }

    func removePage(for key: String) {
        cache.removeValue(forKey: key)
        galleryHandlers.removeValue(forKey: key)
    }
}
