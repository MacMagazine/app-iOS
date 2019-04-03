//
//  PlayerWebView.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Foundation
import WebKit

class PlayerWebView: UIViewController {

    // MARK: - Properties -

    @IBOutlet private weak var webView: WKWebView!

    var podcast: String? {
        didSet {
            guard let html = podcast?.replacingOccurrences(of: "auto_play=false", with: "auto_play=true").replacingOccurrences(of: "\"></iframe>", with: "&sharing=false&download=false&buying=false&visual=true\" style=\"height:\(webView.frame.height * 3)\"></iframe>") else {

                guard let url = URL(string: "about:blank") else {
                    return
                }
                webView.load(URLRequest(url: url))
                return
            }
            webView.loadHTMLString(html, baseURL: nil)
        }
    }

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
