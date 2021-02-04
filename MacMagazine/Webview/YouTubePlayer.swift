//
//  YouTubePlayer.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 14/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit
import WebKit

class YouTubePlayer: WKWebView {

	// MARK: - Properties -

	var embedVideoHtml: String {
		return """
		<!DOCTYPE html><html>
		<style>body,html,iframe{margin:0;padding:0;}</style>
		<body><div id="player"></div>
		<script>
		var meta = document.createElement('meta');
		meta.setAttribute('name', 'viewport');
		meta.setAttribute('content', 'width=device-width');
		document.getElementsByTagName('head')[0].appendChild(meta);
		var tag = document.createElement('script');
		tag.src = "https://www.youtube.com/iframe_api";
		var firstScriptTag = document.getElementsByTagName('script')[0];
		firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
		var player;
		function onYouTubeIframeAPIReady() {
		player = new YT.Player('player', {
		playerVars: { 'playsinline': 0, 'controls': 1, 'fs': 1 },
		height: '\(self.frame.height)',
		width: '\(self.frame.width)',
		videoId: '\(videoId ?? "")',
		events: { 'onReady': onPlayerReady, 'onStateChange': videoPaused }
		});
		}
		function onPlayerReady(event) { event.target.playVideo(); }
		function videoPaused(event) {
		if (event.data == YT.PlayerState.PAUSED) {
		window.webkit.messageHandlers.videoPaused.postMessage(event.data);
		}
		}
		</script>
		</body></html>
		"""
	}

	var videoId: String? {
		didSet {
			guard let _ = videoId else {
				return
			}
			delay(0.4) {
				self.loadHTMLString(self.embedVideoHtml, baseURL: nil)
			}
		}
	}

	func play() {
		self.evaluateJavaScript("player.playVideo()")
	}

}
