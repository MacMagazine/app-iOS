//
//  WebViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 30/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate {
	func previewActionFavorite(_ post: PostData?)
	func previewActionShare(_ post: PostData?)
	func previewActionCancel()
}

class WebViewController: UIViewController, WKNavigationDelegate {

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

	// MARK: - View lifecycle -

	override func viewDidLoad() {
        super.viewDidLoad()
    	// Do any additional setup after loading the view.
		NotificationCenter.default.addObserver(self, selector: #selector(reload(_:)), name: NSNotification.Name(rawValue: "reloadWeb"), object: nil)

		webView?.navigationDelegate = self

		favorite.image = UIImage(named: post?.favorito ?? false ? "fav_on" : "fav_off")

		self.parent?.navigationItem.rightBarButtonItem = nil
		self.parent?.navigationItem.rightBarButtonItems = [share, favorite]

		configureView()
    }

	// MARK: - Notifications -

	@objc func reload(_ notification: Notification) {
		configureView()
	}

	// MARK: - WebView Delegate -

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
		self.parent?.navigationItem.rightBarButtonItem = nil
		self.parent?.navigationItem.rightBarButtonItems = [share, favorite]
	}

	func configureView() {
		// Changes the WKWebView user agent in order to hide some CSS/HTML elements
		webView?.customUserAgent = "MacMagazine\(Settings().getDarkModeUserAgent())\(Settings().getFontSizeUserAgent())"

		// Update the user interface for the detail item.
		guard let post = post,
			let link = post.link,
			let url = URL(string: link)
			else {
				return
		}

		self.parent?.navigationItem.rightBarButtonItems = nil
		self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spin)

		let request = URLRequest(url: url)
		webView?.load(request)
		webView?.allowsBackForwardNavigationGestures = false
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
