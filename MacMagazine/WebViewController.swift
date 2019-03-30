//
//  WebViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 30/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

	// MARK: - Properties -

	@IBOutlet private weak var webView: WKWebView!
	@IBOutlet private weak var spin: UIActivityIndicatorView!
	@IBOutlet private weak var share: UIBarButtonItem!

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
			guard let vc = self.parent?.parent?.parent?.children[0] as? PostsMasterViewController else {
				return
			}
			for item in items {
				guard let post = vc.fetchController?.object(with: "\(item)") else {
					continue
				}
				post.favorite = !post.favorite
				CoreDataStack.shared.save()
			}
		}

		let items: [Any] = [post.title ?? "", url]
		let ac = UIActivityViewController(activityItems: items, applicationActivities: [customItem])
		present(ac, animated: true)
	}

}
