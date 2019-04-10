//
//  LoadingController.swift
//  MacMagazineWatch Extension
//
//  Created by Cassio Rossi on 10/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import EMTLoadingIndicator
import WatchConnectivity
import WatchKit

class LoadingController: WKInterfaceController {

    // MARK: - Properties -

	@IBOutlet private weak var reloadGroup: WKInterfaceGroup!
	@IBOutlet weak var spin: WKInterfaceImage!

	private var indicator: EMTLoadingIndicator?
	var retries = 3

    var posts: [PostData]? {
        didSet {
            if let _posts = posts, !_posts.isEmpty {
				let pages: [String] = Array(1..._posts.count).compactMap {
					"Page\($0)"
				}
				let contexts: [[String: Any]] = _posts.enumerated().compactMap { index, element in
					["title": "\(index + 1) de \(_posts.count)", "post": element]
				}
				DispatchQueue.main.async {
					WKInterfaceController.reloadRootPageControllers(withNames: pages, contexts: contexts, orientation: .horizontal, pageIndex: 0)
				}
			} else {
				if retries > 0 {
					retries -= 1
					getPosts()
				} else {
					indicator?.hide()
					reloadGroup.setHidden(false)
				}
			}
        }
    }

    // MARK: - App lifecycle -

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
		indicator = EMTLoadingIndicator(interfaceController: self, interfaceImage: spin, width: 40, height: 40, style: .line)

		reloadGroup.setHidden(true)

		if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didAppear() {
        super.didAppear()

        if posts?.isEmpty ?? true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.getPosts()
            }
        }
    }

    @IBAction private func load() {
        getPosts()
    }

    func getPosts() {
        if WCSession.default.isReachable {

			indicator?.showWait()

			WCSession.default.sendMessage(["request": "posts"], replyHandler: { response in
                guard let jsonData = response["posts"] as? Data else {
                    self.posts = nil
                    return
                }

				do {
                    self.posts = try JSONDecoder().decode([PostData].self, from: jsonData)
                } catch {
					logE(error.localizedDescription)
                }

            }, errorHandler: { error in
				logE(error.localizedDescription)
            })
        } else {
			logE("Companion Not Reachable")
        }
    }

}

extension LoadingController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
