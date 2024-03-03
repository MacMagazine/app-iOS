import CommonLibrary
import CoreLibrary
import SwiftUI
import WebKit

class WebviewController: NSObject {
	@Binding private var isPresenting: Bool
	@Binding private var removeAds: Bool

	override init() {
		_isPresenting = .constant(false)
		_removeAds = .constant(false)
	}

	init(isPresenting: Binding<Bool>,
		 removeAds: Binding<Bool>) {
		_isPresenting = isPresenting
		_removeAds = removeAds
	}

	var userScripts: [WKUserScript] {
		var scripts = [WKUserScript]()

		// Disable Gallery
		let disableGalleryScriptSource = """
   var links = document.getElementsByClassName('fancybox');
   for(var i = 0; i < links.length; i++) {
  links[i].href = 'javascript:void(0);return false;';
   }
  """
		let galleryScript = WKUserScript(source: disableGalleryScriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
		scripts.append(galleryScript)

		// Disable Gallery - site novo
		let disableNewGalleryScriptSource = """
  var links = document.getElementsByClassName('pk-image-popup');
   for(var i = 0; i < links.length; i++) {
  links[i].href = 'javascript:void(0);return false;';
   }
  """
		let newGalleryScript = WKUserScript(source: disableNewGalleryScriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
		scripts.append(newGalleryScript)

		// Prevent tracking
		let removeBackToBlogScriptSource = "document.getElementById('backtoblog').outerHTML = '';"
		let removeBackToBlogScript = WKUserScript(source: removeBackToBlogScriptSource,
												  injectionTime: .atDocumentEnd,
												  forMainFrameOnly: true)
		scripts.append(removeBackToBlogScript)

		// Tap image to zoom
		let imageScriptSource = """
   var images = document.querySelectorAll('[data-full-url]');
   for(var i = 0; i < images.length; i++) {
  images[i].addEventListener("click", function() {
  window.webkit.messageHandlers.imageTappedHandler.postMessage(this.dataset.fullUrl);
  }, false);
   }
  """
		let imageScript = WKUserScript(source: imageScriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
		scripts.append(imageScript)

		// Get URL for comments
		let commentsScriptSource = """
   var comments = document.querySelectorAll('[data-disqus-identifier]');
   window.webkit.messageHandlers.gotCommentURLHandler.postMessage(comments[0].dataset.disqusIdentifier);
  """
		let commmentsScript = WKUserScript(source: commentsScriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
		scripts.append(commmentsScript)

		return scripts
	}

	var scriptMessageHandlers: [(WKScriptMessageHandler, String)] {
		var scripts = [(WKScriptMessageHandler, String)]()

		// Tap image to zoom
		scripts.append((self, "imageTappedHandler"))

		// Get URL for comments
		scripts.append((self, "gotCommentURLHandler"))

		return scripts
	}

}

// MARK: - WebView Delegate -

extension WebviewController: WKNavigationDelegate {

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
		print("DONE")
	}

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
			if navigationAction.request.url?.absoluteString.contains("comments://") ?? false {
				if let URL = navigationAction.request.url?.absoluteString.replacingOccurrences(of: "comments://", with: "") {
//					commentsURL = URL.replacingOccurrences(of: "%20", with: " ")
//					self.performSegue(withIdentifier: "showCommentsSegue", sender: self)
				}
			} else if navigationAction.request.url?.absoluteString.contains("#disqus_thread") ?? false {
//				self.performSegue(withIdentifier: "showCommentsSegue", sender: self)
			} else if navigationAction.request.url?.absoluteString.hasSuffix(".pkpass") ?? false {
				if let url = navigationAction.request.url {
//					openPassKit(url: url)
				}
			} else {
//				openURLinBrowser(url)
			}
			actionPolicy = .cancel

		case .other:
			if url.absoluteString == navigationAction.request.mainDocumentURL?.absoluteString &&
				webView.isLoading {
				if navigationAction.request.url?.absoluteString.contains("https://disqus.com/next/login-success") ?? false {
					actionPolicy = .cancel
//					self.navigationController?.popViewController(animated: true)
//					NotificationCenter.default.post(name: .reloadAfterLogin, object: nil)
				}
			}

		default:
			break
		}
		decisionHandler(actionPolicy)
	}
}

// MARK: - Private Methods -

extension WebviewController: WKScriptMessageHandler {
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		switch message.name {
		case "imageTappedHandler":
			guard let body = message.body as? String,
				  let url = URL(string: body) else {
				return
			}
			print("openInSafari(\(url)")
//			if url.isMMAddress() &&
//				!url.isAppStoreBadge() {
//				openInSafari(url)
//			}

		case "gotCommentURLHandler":
			guard let body = message.body as? String else {
				return
			}
			print(body)
//			commentsURL = body

		default:
			break
		}
	}
}

// MARK: - Private Methods -

extension WebviewController {
}
