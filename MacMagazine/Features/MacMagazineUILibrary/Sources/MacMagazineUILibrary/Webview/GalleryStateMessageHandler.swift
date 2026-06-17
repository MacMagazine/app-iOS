import WebKit

/// Receives gallery open/close notifications posted by
/// `MMWebViewUserScripts.galleryStateObserver`.
@MainActor
final class GalleryStateMessageHandler: NSObject, WKScriptMessageHandler {
    static let handlerName = "mmGalleryState"

    var onGalleryStateChange: ((Bool) -> Void)?

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard let isOpen = message.body as? Bool else { return }
        onGalleryStateChange?(isOpen)
    }
}
