//
//  WebViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 30/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import SafariServices
import UIKit
import WebKit

protocol WebViewControllerDelegate {
	func previewActionFavorite(_ post: PostData?)
	func previewActionShare(_ post: PostData?)
	func previewActionCancel()
}

class WebViewController: UIViewController {

	// MARK: - Properties -

	@IBOutlet private weak var webView: WKWebView!
	@IBOutlet private weak var spin: UIActivityIndicatorView!
	@IBOutlet private weak var share: UIBarButtonItem!
	@IBOutlet private weak var favorite: UIBarButtonItem!

	var delegate: WebViewControllerDelegate?

	var post: PostData? {
		didSet {
			configureView()
		}
	}

	var postURL: URL? {
		didSet {
			guard let url = postURL else {
				return
			}
			loadWebView(url: url)
		}
	}

	var forceReload: Bool = false
	var previousIsDarkMode: Bool = false
	var previousFonteSize: String = ""

	// MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

		// Do any additional setup after loading the view.
		NotificationCenter.default.addObserver(self, selector: #selector(reload(_:)), name: .reloadWeb, object: nil)

		favorite.image = UIImage(named: post?.favorito ?? false ? "fav_on" : "fav_off")
		self.parent?.navigationItem.rightBarButtonItems = [share, favorite]
        self.parent?.navigationItem.leftBarButtonItem?.accessibilityLabel = "Voltar"

        webView?.navigationDelegate = self
		webView?.uiDelegate = self

        let scriptSource = """
            var images = document.getElementsByTagName('img');
            for(var i = 0; i < images.length; i++) {
                images[i].addEventListener("click", function() {
                    window.webkit.messageHandlers.imageTapped.postMessage(this.src);
                }, false);
            }
        """
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView?.configuration.userContentController.addUserScript(script)

        webView?.configuration.userContentController.add(self, name: "imageTapped")

        setupCookies()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		NotificationCenter.default.addObserver(self, selector: #selector(onFavoriteUpdated(_:)), name: .favoriteUpdated, object: nil)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		NotificationCenter.default.removeObserver(self, name: .favoriteUpdated, object: nil)
	}

	// MARK: - Local methods -

    fileprivate func setupCookies() {
        // Make sure that all cookies are loaded before continue
        // to prevent Disqus from being loogoff
        // and to set MM properties to load right the content
        webView?.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            var cookies = cookies

            // Dark mode
            if let darkmode = HTTPCookie(properties: [
                .domain: API.APIParams.mmDomain,
                .path: "/",
                .name: "darkmode",
                .value: Settings().darkModeUserAgent,
                .secure: "false",
                .expires: NSDate(timeIntervalSinceNow: 31556926)
            ]) {
                cookies.append(darkmode)
            }

            // Font size
            if let font = HTTPCookie(properties: [
                .domain: API.APIParams.mmDomain,
                .path: "/",
                .name: "fonte",
                .value: Settings().fontSizeUserAgent,
                .secure: "false",
                .expires: NSDate(timeIntervalSinceNow: 31556926)
            ]) {
                cookies.append(font)
            }

            // Disqus cookies
            cookies.append(contentsOf: API().getDisqusCookies())

            var cookiesLeft = cookies.count
            if cookies.isEmpty {
                self.reload()
            } else {
                cookies.forEach { cookie in
                    if cookie.name == "patr" && !Settings().isPatrao {
                        self.webView?.configuration.websiteDataStore.httpCookieStore.delete(cookie) {
                            cookiesLeft -= 1
                            if cookiesLeft <= 0 {
                                DispatchQueue.main.async {
                                    self.reload()
                                }
                            }
                        }
                    } else {
                        self.webView?.configuration.websiteDataStore.httpCookieStore.setCookie(cookie) {
                            cookiesLeft -= 1
                            if cookiesLeft <= 0 {
                                DispatchQueue.main.async {
                                    self.reload()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

	func configureView() {
		// Update the user interface for the detail item.
		guard let post = post,
			let link = post.link,
			let url = URL(string: link)
			else {
				return
		}

        if webView?.url != url ||
			forceReload {
			loadWebView(url: url)
        }
	}

	func loadWebView(url: URL) {
		previousIsDarkMode = Settings().isDarkMode
		previousFonteSize = Settings().fontSizeUserAgent

        // Changes the WKWebView user agent in order to hide some CSS/HT elements
        webView?.customUserAgent = "MacMagazine"
        webView?.allowsBackForwardNavigationGestures = false
        webView?.load(URLRequest(url: url))

        self.parent?.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: spin)]
        forceReload = false
	}

	// MARK: - Actions -

	@IBAction private func favorite(_ sender: Any) {
		guard let post = post,
			let link = post.link
			else {
				return
		}
		Favorite().updatePostStatus(using: link) { isFavoriteOn in
			self.favorite.image = UIImage(named: isFavoriteOn ? "fav_on" : "fav_off")
		}
	}

	@IBAction private func share(_ sender: Any) {
		guard let post = post,
			let link = post.link,
			let url = URL(string: link)
			else {
                guard let url = postURL else {
                    return
                }
                let items: [Any] =  [webView.title ?? "", url]
                Share().present(at: share, using: items)
                return
		}
		let items: [Any] =  [post.title ?? "", url]
		Share().present(at: share, using: items)
	}

	// MARK: - UIPreviewAction -

	override var previewActionItems: [UIPreviewActionItem] {
		let favoritar = UIPreviewAction(title: "Favoritar", style: .default) { [weak self] _, _ in
			self?.delegate?.previewActionFavorite(self?.post)
		}
		let compartilhar = UIPreviewAction(title: "Compartilhar", style: .default) { [weak self] _, _ in
			self?.delegate?.previewActionShare(self?.post)
		}
		let cancelar = UIPreviewAction(title: "Cancelar", style: .destructive) { [weak self] _, _  in
			self?.delegate?.previewActionCancel()
		}

		// Temporary change the colors
		Settings().applyLightTheme()

		return [favoritar, compartilhar, cancelar]
	}

}

// MARK: - Notifications -

extension WebViewController {

	func reload() {
		if post != nil {
			configureView()
		} else if postURL != nil {
			guard let url = postURL else {
				return
			}
            loadWebView(url: url)
			self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: spin)]
		}
	}

	@objc func reload(_ notification: Notification) {
		if previousIsDarkMode != Settings().isDarkMode ||
			previousFonteSize != Settings().fontSizeUserAgent ||
            notification.object != nil {

            forceReload = true
            reload()
		}
	}

	@objc func onFavoriteUpdated(_ notification: Notification) {
		if Settings().isPad {
			guard let object = notification.object as? Post else {
				return
			}
			if post?.link == object.link {
				post?.favorito = object.favorite
				favorite.image = UIImage(named: post?.favorito ?? false ? "fav_on" : "fav_off")
				self.parent?.navigationItem.rightBarButtonItems = [share, favorite]
			}
		}
	}

}

// MARK: - WebView Delegate -

extension WebViewController: WKNavigationDelegate, WKUIDelegate {

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
		self.parent?.navigationItem.rightBarButtonItems = [share, favorite]
		self.navigationItem.rightBarButtonItems = nil

        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            if !(webView.url?.absoluteString.contains("loginpatrao") ?? true) {
                self.navigationItem.rightBarButtonItems = [share]
            }
        }
    }

	func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

		if !(navigationAction.targetFrame?.isMainFrame ?? false) {
			guard let url = navigationAction.request.url else {
				return nil
			}

			if url.isKnownAddress() {
				pushNavigation(url)
			} else {
				openInSafari(url)
			}
		}
		return nil
	}

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		var actionPolicy: WKNavigationActionPolicy = .allow

		guard let url = navigationAction.request.url else {
			decisionHandler(actionPolicy)
			return
		}

        switch navigationAction.navigationType {
		case .linkActivated:
            openURLinBrowser(url)
			actionPolicy = .cancel

        case .formSubmitted:
            if url.absoluteString == navigationAction.request.mainDocumentURL?.absoluteString {
                if webView.isLoading {
                    if checkIsDesiredURL(webView.url?.absoluteString) {
                        actionPolicy = .cancel
                    }
                }
            }

		case .other:
			if url.absoluteString == navigationAction.request.mainDocumentURL?.absoluteString {
				if webView.isLoading {
                    if checkIsDesiredURL(webView.url?.absoluteString) {
                        actionPolicy = .cancel
                    }
				} else {
                    openURLinBrowser(url)
					actionPolicy = .cancel
				}
			}

		default:
			break
		}

		decisionHandler(actionPolicy)
	}

    fileprivate func backAndReload() {
        webView?.navigationDelegate = nil
        webView?.uiDelegate = nil
        webView = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.navigationController?.popViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                NotificationCenter.default.post(name: .reloadWeb, object: true)
            }
        }
    }

    fileprivate func checkIsDesiredURL(_ url: String?) -> Bool {
        let mmURL = "https://macmagazine.uol.com.br/wp-admin/profile.php"
        let disqusURL = "https://disqus.com/next/login-success/"

        var returnValue = false
        if url == mmURL ||
            url == disqusURL {
            returnValue = true

            if url == mmURL {
                var settings = Settings()
                settings.isPatrao = true
            }
            backAndReload()
        }
        return returnValue
    }

    fileprivate func openURLinBrowser(_ url: URL) {
        if url.isMMAddress() {
            pushNavigation(url)
        } else {
            openInSafari(url)
        }
    }

}

extension WebViewController {

	func pushNavigation(_ url: URL) {
        // Prevent double pushViewController due decidePolicyFor navigationAction == .other
        if self.navigationController?.viewControllers.count ?? 0 <= 1 {
            let storyboard = UIStoryboard(name: "WebView", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "PostDetail") as? WebViewController else {
                return
            }
            controller.postURL = url

            controller.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            loadWebView(url: url)
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: spin)]
        }
	}

	func openInSafari(_ url: URL) {
		if url.scheme?.lowercased().contains("http") ?? false {
			let safari = SFSafariViewController(url: url)
            safari.setup()
			self.present(safari, animated: true, completion: nil)
		}
	}

}

extension WebViewController {
	func delay(_ delay: Double, closure: @escaping () -> Void) {
		let when = DispatchTime.now() + delay
		DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
	}
}

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? String,
            let url = URL(string: body) else {
            return
        }
        if url.isMMAddress() {
            openInSafari(url)
        }
    }
}
