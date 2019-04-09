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

	// MARK: - View lifecycle -

	override func viewDidLoad() {
        super.viewDidLoad()
    	// Do any additional setup after loading the view.
		NotificationCenter.default.addObserver(self, selector: #selector(reload(_:)), name: .reloadWeb, object: nil)

		webView?.navigationDelegate = self
		webView?.uiDelegate = self

		favorite.image = UIImage(named: post?.favorito ?? false ? "fav_on" : "fav_off")

		self.parent?.navigationItem.rightBarButtonItems = [share, favorite]

		reload()
    }

	// MARK: - Notifications -

	func reload() {
		if post != nil {
			configureView()
		} else {
			guard let url = postURL else {
				return
			}
			loadWebView(url: url)

			self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: spin)]
		}
	}

	@objc func reload(_ notification: Notification) {
		reload()
	}

	// MARK: - Local methods -

	func configureView() {
		// Update the user interface for the detail item.
		guard let post = post,
			let link = post.link,
			let url = URL(string: link)
			else {
				return
		}

		loadWebView(url: url)
	}

	func loadWebView(url: URL) {
		UserDefaults.standard.removeObject(forKey: "offset")

		// Changes the WKWebView user agent in order to hide some CSS/HT elements
		webView?.customUserAgent = "MacMagazine\(Settings().getDarkModeUserAgent())\(Settings().getFontSizeUserAgent())"
		webView?.allowsBackForwardNavigationGestures = false
		webView?.load(URLRequest(url: url))

		self.parent?.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: spin)]
	}

	// MARK: - Actions -

	@IBAction private func favorite(_ sender: Any) {
		guard let post = post,
			let link = post.link
			else {
				return
		}

		CoreDataStack.shared.get(post: link) { items in
			if !items.isEmpty {
				items[0].favorite = !items[0].favorite
				CoreDataStack.shared.save()
				self.favorite.image = UIImage(named: items[0].favorite ? "fav_on" : "fav_off")
			}
		}
	}

	@IBAction private func share(_ sender: Any) {
		guard let post = post,
			let link = post.link,
			let url = URL(string: link)
			else {
				return
		}

		let safari = UIActivityExtensions(title: "Abrir no Safari", image: UIImage(named: "safari")) { items in
			for item in items {
				guard let url = URL(string: "\(item)") else {
					continue
				}
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}
		}

		let chrome = UIActivityExtensions(title: "Abrir no Chrome", image: UIImage(named: "chrome")) { items in
			for item in items {
				guard let url = URL(string: "\(item)".replacingOccurrences(of: "http", with: "googlechrome")) else {
					continue
				}
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}
		}
		var activities = [safari]
		if let url = URL(string: "googlechrome://"),
			UIApplication.shared.canOpenURL(url) {
			activities.append(chrome)
		}

		let items: [Any] =  [post.title ?? "", url]
		let activityVC = UIActivityViewController(activityItems: items, applicationActivities: activities)
		if let ppc = activityVC.popoverPresentationController {
			ppc.barButtonItem = share
		}
		present(activityVC, animated: true)
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
		return [favoritar, compartilhar, cancelar]
	}

}

// MARK: - WebView Delegate -

extension WebViewController: WKNavigationDelegate, WKUIDelegate {

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
		self.parent?.navigationItem.rightBarButtonItems = [share, favorite]
		self.navigationItem.rightBarButtonItems = nil
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
		let isMMAddress = url.isMMAddress()

		switch navigationAction.navigationType {
		case .linkActivated:
			if isMMAddress {
				pushNavigation(url)
			} else {
				openInSafari(url)
			}
			actionPolicy = .cancel

		case .other:
			if url.absoluteString == navigationAction.request.mainDocumentURL?.absoluteString {
				if webView.isLoading {
					if webView.url?.absoluteString == "https://disqus.com/next/login-success/" {
						actionPolicy = .cancel
						self.navigationController?.popViewController(animated: true)
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
							NotificationCenter.default.post(name: .reloadWeb, object: nil)
						}
					}
				} else {
					if isMMAddress {
						pushNavigation(url)
					} else {
						openInSafari(url)
					}
					actionPolicy = .cancel
				}
			}

		default:
			break
		}

		decisionHandler(actionPolicy)
	}

}

extension WebViewController {

	func pushNavigation(_ url: URL) {
		let storyboard = UIStoryboard(name: "WebView", bundle: nil)
		guard let controller = storyboard.instantiateViewController(withIdentifier: "PostDetail") as? WebViewController else {
			return
		}
		controller.postURL = url

		controller.modalPresentationStyle = .overFullScreen
		self.navigationController?.pushViewController(controller, animated: true)
	}

	func openInSafari(_ url: URL) {
		if url.scheme?.lowercased().contains("http") ?? false {
			let safari = SFSafariViewController(url: url)
			safari.modalPresentationStyle = .overFullScreen
			self.present(safari, animated: true, completion: nil)
		}
	}

}

// MARK: - Extensions -

extension URL {

	enum Address {
		static let disqus = "disqus.com"
		static let macmagazine = "macmagazine.uol.com.br"
	}

	func isKnownAddress() -> Bool {
		return self.absoluteString.contains(Address.disqus) ||
			self.absoluteString.contains(Address.macmagazine)
	}

	func isMMAddress() -> Bool {
		return self.absoluteString.contains(Address.macmagazine)
	}

	func isDisqusAddress() -> Bool {
		return self.absoluteString.contains(Address.disqus)
	}

}
