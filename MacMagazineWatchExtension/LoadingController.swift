//
//  LoadingController.swift
//  MacMagazineWatch Extension
//
//  Created by Cassio Rossi on 10/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Kingfisher
import WatchConnectivity
import WatchKit

class LoadingController: WKInterfaceController {

    // MARK: - Properties -

	@IBOutlet private weak var reloadGroup: WKInterfaceGroup!
	@IBOutlet private weak var loadingLabel: WKInterfaceLabel!

	var retries = 3

    var posts: [PostData]? {
        didSet {
            if let _posts = posts, !_posts.isEmpty {
				DispatchQueue.main.async {
                    let pages: [String] = Array(0..._posts.count).compactMap {
                        "Page\($0)"
                    }
                    var contexts: [[String: Any]] = _posts.enumerated().compactMap { index, element in
                        ["title": "\(index + 1) de \(_posts.count)", "post": element]
                    }
                    contexts.insert(["title": "MacMagazine", "post": ""], at: 0)

                    // Prefetch images to be able to sent to Apple Watch
                    let urls: [URL] = _posts.compactMap {
                        guard let thumbnail = $0.thumbnail else {
                            return nil
                        }
                        return URL(string: thumbnail)
                    }
                    ImagePrefetcher(urls: urls, completionHandler: { _, _, _ in
                        WKInterfaceController.reloadRootPageControllers(withNames: pages, contexts: contexts, orientation: .horizontal, pageIndex: 1)
                    }).start()
				}
			} else {
				if retries > 0 {
					retries -= 1
					getPosts()
				} else {
                    loadingLabel.setHidden(true)
					reloadGroup.setHidden(false)
				}
			}
        }
    }

    // MARK: - App lifecycle -

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
		// Schedule a background task to reload data for the Complication
		WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(), userInfo: nil) { _ in }

        loadingLabel.setHidden(false)
		reloadGroup.setHidden(true)

		if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    override func didAppear() {
        super.didAppear()

        if posts?.isEmpty ?? true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.getPosts()
            }
        }
    }

    @IBAction private func load() {
		WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(), userInfo: nil) { _ in }

        loadingLabel.setHidden(false)
		reloadGroup.setHidden(true)

        retries = 3
        getPosts()
    }

    func getPosts() {
        if WCSession.default.isReachable {
			WCSession.default.sendMessage(["request": "posts"], replyHandler: { response in
                guard let jsonData = response["posts"] as? Data else {
                    logE("Failed receive response from companion App.")
                    self.posts = nil
                    return
                }

				do {
                    self.posts = try JSONDecoder().decode([PostData].self, from: jsonData)
                } catch {
					logE(error.localizedDescription)
                    self.posts = []
                }

            }, errorHandler: { error in
				logE(error.localizedDescription)
                self.posts = []
            })
        } else {
            logE("Companion not reachable")
            self.posts = []
        }
    }

}

extension LoadingController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
