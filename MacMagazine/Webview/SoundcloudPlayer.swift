//
//  SoundcloudPlayer.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 20/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import AVFoundation
import UIKit
import WebKit

class SoundcloudPlayer: WKWebView {

	// MARK: - Properties -

    var soundEffect: AVAudioPlayer?

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
        UIApplication.shared.isIdleTimerDisabled = true
		self.evaluateJavaScript("widget1.play()")
        startListeners()
	}

	func pause() {
        UIApplication.shared.isIdleTimerDisabled = false
		self.evaluateJavaScript("widget1.pause()")
        soundEffect?.stop()
        stopListeners()
    }

}

// MARK: - WebView Delegate -

extension SoundcloudPlayer: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
		if let resource = Bundle.main.path(forResource: "soundcloud", ofType: "js") {
			do {
				let code = try String(contentsOfFile: resource, encoding: .utf8)
				self.evaluateJavaScript(code) { _, _ in
					delay(0.2) {
						self.evaluateJavaScript(self.soundCloudWidget) { _, _ in
							delay(0.2) {
								self.play()
							}
						}
					}
				}
			} catch {
				logE(error.localizedDescription)
			}
		}
	}
}

extension SoundcloudPlayer {
    func startListeners() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(self,
                                       selector: #selector(appMovedToBackground),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(appMovedToForeground),
                                       name: UIApplication.willEnterForegroundNotification,
                                       object: nil)
    }

    func stopListeners() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.removeObserver(self,
                                          name: UIApplication.willEnterForegroundNotification,
                                          object: nil)

        notificationCenter.removeObserver(self,
                                          name: UIApplication.didEnterBackgroundNotification,
                                          object: nil)
    }

    @objc func appMovedToBackground() {
        guard let path = Bundle.main.path(forResource: "sound.wav", ofType: nil) else {
                return
        }
        let url = URL(fileURLWithPath: path)

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)

            soundEffect = try AVAudioPlayer(contentsOf: url)
            soundEffect?.volume = 0
            soundEffect?.numberOfLoops = -1
            soundEffect?.play()
        } catch {
            logE(error.localizedDescription)
        }
    }

    @objc func appMovedToForeground() {
        soundEffect?.stop()
    }
}
