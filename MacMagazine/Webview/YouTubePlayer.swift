import UIKit
import WebKit

enum YouTubePlayerState: Int {
	case unstarted = -1
	case ended = 0
	case playing = 1
	case paused = 2
	case buffering = 3
	case videoCued = 5
	case unknown = 6

	var description: String {
		switch self {
		case .unstarted: return "unstarted"
		case .ended: return "ended"
		case .playing: return "playing..."
		case .paused: return "paused"
		case .buffering: return "buffering"
		case .videoCued: return "video_cued"
		case .unknown: return "unknown"
		}
	}
}

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
  playerVars: { 'playsinline': 1, 'controls': 1, 'fs': 1, 'enablejsapi': 1 },
  height: '100%',
  width: '100%',
  videoId: '\(videoId ?? "")',
  events: { 'onReady': onPlayerReady, 'onStateChange': stateChanged }
  });
  }
  function onPlayerReady(event) { event.target.playVideo(); }
  function stateChanged(event) {
  window.webkit.messageHandlers.stateChanged.postMessage(event.data);
  if (event.data == YT.PlayerState.CUED) {
  player.playVideo();
  }
  if (event.data == YT.PlayerState.PAUSED) {
  window.webkit.messageHandlers.videoPaused.postMessage(player.getCurrentTime());
  }
  if (event.data == YT.PlayerState.ENDED) {
  window.webkit.messageHandlers.videoPaused.postMessage(0);
  }
  }
  </script>
  </body></html>
  """
	}

	var autoPlay = true
	var time: Double = 0
	var videoId: String?

	func play() {
		self.evaluateJavaScript("player.playVideo()")
	}

	func play(time: Double) {
		if time > 0 {
			self.time = time
			self.evaluateJavaScript("player.seekTo(\(time))")
		}
		play()
	}

	func load(_ video: String) {
		videoId = video
		self.navigationDelegate = self
		self.loadHTMLString(self.embedVideoHtml, baseURL: nil)
	}

	func cue(_ video: String, time: Double = 0) {
		self.evaluateJavaScript("player.cueVideoById('\(video)',\(time));")
	}

	func state(_ state: Int) -> YouTubePlayerState {
		YouTubePlayerState(rawValue: state) ?? .unknown
	}
}

extension YouTubePlayer: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
		if autoPlay {
			delay(0.1) {
				self.play(time: self.time)
			}
		}
	}
}
