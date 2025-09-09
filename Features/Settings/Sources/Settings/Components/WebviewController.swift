import CommonLibrary
import CoreLibrary
import SwiftUI
import WebKit

class WebviewController: NSObject {
	@Binding private var isPresenting: Bool
	@Binding private var isPatrao: Bool

	override init() {
		_isPresenting = .constant(false)
		_isPatrao = .constant(false)
	}

	init(isPresenting: Binding<Bool>,
		 isPatrao: Binding<Bool>) {
		_isPresenting = isPresenting
		_isPatrao = isPatrao
	}

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

	func webView(_ webView: WKWebView,
				 decidePolicyFor navigationAction: WKNavigationAction,
				 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

		var actionPolicy: WKNavigationActionPolicy = .allow

		guard let url = navigationAction.request.url else {
			decisionHandler(actionPolicy)
			return
		}

		switch navigationAction.navigationType {
		case .linkActivated:
			isPresenting = false
			Utils.delay(0.2) {
				Utils.openInSafari(url)
			}
			actionPolicy = .cancel

		case .formSubmitted:
			if url.absoluteString == navigationAction.request.mainDocumentURL?.absoluteString &&
				webView.isLoading {
				actionPolicy = processLogin(for: webView.url?.absoluteString)
			}

		default:
			break
		}
		decisionHandler(actionPolicy)
	}
}

// MARK: - Private Methods -

extension WebviewController {
	private func processLogin(for url: String?) -> WKNavigationActionPolicy {
		var actionPolicy: WKNavigationActionPolicy = .allow

		if url == APIParams.patraoSuccessUrl {
			actionPolicy = .cancel

			isPatrao = true
			isPresenting = false
		}
		return actionPolicy
	}
}
