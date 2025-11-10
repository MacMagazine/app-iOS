import MacMagazineLibrary
import SwiftUI
import WebKit

class WebviewController: NSObject {
	@Binding private var isPresenting: Bool
	@Binding private var isPatrao: Bool
    @Binding private var openUrl: URL?

	override init() {
		_isPresenting = .constant(false)
		_isPatrao = .constant(false)
        _openUrl = .constant(nil)
	}

	init(isPresenting: Binding<Bool>,
         isPatrao: Binding<Bool>,
         openUrl: Binding<URL?>) {
		_isPresenting = isPresenting
		_isPatrao = isPatrao
        _openUrl = openUrl
	}

    @MainActor
	var userScripts: [WKUserScript] {
		var scripts = [WKUserScript]()

		// Prevent tracking
		let removeBackToBlogScriptSource = "document.getElementById('backtoblog').outerHTML = '';"
		let removeBackToBlogScript = WKUserScript(source: removeBackToBlogScriptSource,
												  injectionTime: .atDocumentEnd,
												  forMainFrameOnly: true)
		scripts.append(removeBackToBlogScript)

		return scripts
	}

}

// MARK: - WebView Delegate -

extension WebviewController: WKNavigationDelegate {
    @MainActor
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 preferences: WKWebpagePreferences,
                 decisionHandler: @escaping @MainActor @Sendable (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {

		var actionPolicy: WKNavigationActionPolicy = .allow

		guard let url = navigationAction.request.url else {
			decisionHandler(actionPolicy, preferences)
			return
		}

		switch navigationAction.navigationType {
		case .linkActivated:
            openUrl = url
            isPresenting = false
			actionPolicy = .cancel

		case .formSubmitted:
			if url.absoluteString == navigationAction.request.mainDocumentURL?.absoluteString &&
				webView.isLoading {
				actionPolicy = processLogin(for: webView.url?.absoluteString)
			}

		default:
			break
		}
		decisionHandler(actionPolicy, preferences)
	}
}

// MARK: - Private Methods -

extension WebviewController {
	private func processLogin(for url: String?) -> WKNavigationActionPolicy {
		var actionPolicy: WKNavigationActionPolicy = .allow

        if url == URLs.success {
			actionPolicy = .cancel

			isPatrao = true
			isPresenting = false
		}
		return actionPolicy
	}
}
