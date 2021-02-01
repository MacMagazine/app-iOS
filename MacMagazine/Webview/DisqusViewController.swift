//
//  DisqusViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 09/10/20.
//

import SafariServices
import UIKit
import WebKit

class DisqusViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var spin: UIActivityIndicatorView!

    var commentsURL: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reload(_:)), name: .reloadAfterLogin, object: nil)

        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        webView?.allowsBackForwardNavigationGestures = false
        self.navigationItem.titleView = spin

        self.loadWebView()
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { _ in
            delay(0.8) {
                NotificationCenter.default.post(name: .reloadWeb, object: nil)
                self.loadWebView()
            }
        }
    }

    @objc func reload(_ notification: Notification) {
        delay(0.8) {
            self.loadWebView()
        }
    }

    fileprivate func loadWebView() {
        let color = Settings().isDarkMode ? "black" : "none"
        let content = """
            <html><head>
                <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0">
                <style>body { background-color: \(color); padding: 20px; }</style>
            </head>
            <body><div id='disqus_thread'></div>
            </body></html>
        """

        self.loadDisqus()
        self.webView?.loadHTMLString(content, baseURL: nil)
    }

    @IBAction private func close(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension DisqusViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Comentários"
    }
}

extension DisqusViewController: WKUIDelegate {
    // Triggered when a link is clicked
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        if !(navigationAction.targetFrame?.isMainFrame ?? false) {
            guard let url = navigationAction.request.url else {
                return nil
            }
            pushNavigation(url, forcePush: true)
        }
        return nil
    }
}

extension DisqusViewController {
    func pushNavigation(_ url: URL, forcePush: Bool = false) {
        // Prevent double pushViewController due decidePolicyFor navigationAction == .other
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PostDetail") as? WebViewController else {
            return
        }
        controller.postURL = url
        show(controller, sender: self)
    }
}

extension DisqusViewController {
    func loadDisqus() {
        let content = """
            var disqus_identifier = '\(commentsURL)';
            var disqus_shortname = 'macmagazinecombr';
            (function() { var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true; dsq.src = 'https://macmagazinecombr.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq); })();
        """

        let script = WKUserScript(source: content, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView?.configuration.userContentController.addUserScript(script)
    }
}
