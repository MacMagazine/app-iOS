//
//  DetailViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 18/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import UIKit
import WebKit

class PostsDetailViewController: UIViewController, WKNavigationDelegate {

	// MARK: - Properties -

	@IBOutlet private weak var webView: WKWebView!

	var post: Posts?

	// MARK: - View lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		webView?.navigationDelegate = self

		// Changes the WKWebView user agent in order to hide some CSS/HTML elements
		webView.customUserAgent = "MacMagazine\(Settings().getDarkModeUserAgent())\(Settings().getFontSizeUserAgent())"
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		configureView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - WebView Delegate -

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
		print("finished")
	}

	// MARK: - View methods -

	func configureView() {
		// Update the user interface for the detail item.
		guard let post = post,
			let url = URL(string: post.link)
			else {
				return
		}

		let request = URLRequest(url: url)
		webView?.load(request)
		webView?.allowsBackForwardNavigationGestures = false
	}

}
