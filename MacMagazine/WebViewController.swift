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
		webView?.navigationDelegate = self
		self.parent?.navigationItem.rightBarButtonItem = share

		// Changes the WKWebView user agent in order to hide some CSS/HTML elements
		webView.customUserAgent = "MacMagazine\(Settings().getDarkModeUserAgent())\(Settings().getFontSizeUserAgent())"

		configureView()
    }

	// MARK: - WebView Delegate -

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
		self.parent?.navigationItem.rightBarButtonItem = share
	}

	func configureView() {
		// Update the user interface for the detail item.
		guard let post = post,
			let link = post.link,
			let url = URL(string: link)
			else {
				return
		}

		self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spin)
		let request = URLRequest(url: url)
		webView?.load(request)
		webView?.allowsBackForwardNavigationGestures = false
	}

	// MARK: - Actions -

	@IBAction private func share(_ sender: Any) {
		guard let post = post,
			let link = post.link,
			let url = URL(string: link)
			else {
				return
		}

		let customItem = UIActivityExtensions(title: "Favoritar", image: UIImage(named: "fav_cell")) { items in
			for item in items {
				CoreDataStack.shared.get(post: "\(item)") { items in
					if !items.isEmpty {
						items[0].favorite = !items[0].favorite
						CoreDataStack.shared.save()
					}
				}
			}
		}

		let items: [Any] = [post.title ?? "", url]
		let activityVC = UIActivityViewController(activityItems: items, applicationActivities: [customItem])

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
