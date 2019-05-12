//
//  SoundcloudPlayer.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 20/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit
import WebKit

class SoundcloudPlayer: WKWebView {

	// MARK: - Properties -

	var soundCloudWidget: String {
		return """
		var iframeElement = document.querySelector('iframe');
		var iframeElementID = iframeElement.id;
		var widget1 = SC.Widget(iframeElement);
		var widget2 = SC.Widget(iframeElementID);
		"""
	}

	var embedVideoHtml: String {
		return """
		<!DOCTYPE html><html>
		<style>body,html,iframe{margin:0;padding:0;}</style>
		<script>
		var meta = document.createElement('meta');
		meta.setAttribute('name', 'viewport');
		meta.setAttribute('content', 'width=device-width');
		document.getElementsByTagName('head')[0].appendChild(meta);
		</script>
		<body><div id="player"></div>
		\(iFrame ?? "")
		</body></html>
		"""
	}

	var iFrame: String? {
		didSet {
			guard let _ = iFrame else {
				return
			}
			iFrame = iFrame?.replacingOccurrences(of: "show_artwork=false", with: "show_artwork=false&download=false&sharing=false")

			DispatchQueue.main.async {
				self.navigationDelegate = self
				self.loadHTMLString(self.embedVideoHtml, baseURL: nil)
			}
		}
	}

	// MARK: - Methods -

	func play() {
		self.evaluateJavaScript("widget1.play()")
	}

	func pause() {
		self.evaluateJavaScript("widget1.pause()")
	}

}

// MARK: - WebView Delegate -

extension SoundcloudPlayer: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
		if let resource = Bundle.main.path(forResource: "soundcloud", ofType: "js") {
			do {
				let code = try String(contentsOfFile: resource, encoding: .utf8)
				self.evaluateJavaScript(code) { _, _ in
					self.evaluateJavaScript(self.soundCloudWidget) { _, _ in
						self.play()
					}
				}
			} catch {
				logE(error.localizedDescription)
			}
		}
	}
}
