//
//  MainInterfaceController.swift
//  MacMagazineWatch Extension
//
//  Created by Cassio Rossi on 08/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import WatchConnectivity
import WatchKit

class MainInterfaceController: WKInterfaceController {

	// MARK: - Properties -

	@IBOutlet private weak var image: WKInterfaceImage!
	@IBOutlet private weak var titleLabel: WKInterfaceLabel!
	@IBOutlet private weak var dateLabel: WKInterfaceLabel!
	@IBOutlet private weak var content: WKInterfaceLabel!

	var posts: [PostData]? {
		didSet {
			guard let posts = posts else {
				return
			}
			print(posts.count)
			titleLabel.setText(posts[0].title)
			dateLabel.setText(posts[0].pubDate)
			content.setText(posts[0].excerpt)
		}
	}

	// MARK: - App lifecycle -

	override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
		if WCSession.isSupported() {
			WCSession.default.delegate = self
			WCSession.default.activate()
		}
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
	}

	@IBAction private func load() {
		if WCSession.default.isReachable {
			WCSession.default.sendMessage(["request": "posts"], replyHandler: { response in
				guard let jsonData = response["posts"] as? Data else {
					return
				}
				do {
					self.posts = try JSONDecoder().decode([PostData].self, from: jsonData)
				} catch {
					print(error.localizedDescription)
				}

			}, errorHandler: { error in
				print("Error sending message: %@", error)
			})
		}
	}

	override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension MainInterfaceController: WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
