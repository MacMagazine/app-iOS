//
//  PushNotification.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 21/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Kingfisher
import OneSignal
import UIKit

class PushNotification {
	func setup(options: [UIApplication.LaunchOptionsKey: Any]?) {
		let notificationReceived: OSHandleNotificationActionBlock = { result in
			// This block gets called when the user reacts to a notification received
			guard let payload = result?.notification.payload,
				let additionalData = payload.additionalData,
				let url = additionalData as? [String: String]
				else {
					return
			}
			logD("additionalData = \(additionalData)")
			self.updateDatabase(openURL: url["url"])
		}

		// Prod
		//let key: [UInt8] = [114, 66, 66, 33, 7, 95, 7, 81, 76, 21, 6, 42, 97, 98, 86, 91, 80, 6, 89, 35, 20, 18, 116, 72, 14, 87, 1, 81, 18, 85, 123, 55, 120, 4, 89, 81]
		// Dev
		let key: [UInt8] = [119, 69, 68, 114, 4, 15, 81, 94, 76, 17, 84, 121, 98, 98, 86, 83, 6, 84, 89, 32, 18, 69, 118, 72, 8, 85, 85, 82, 77, 6, 124, 54, 41, 83, 83, 86]

		OneSignal.initWithLaunchOptions(options, appId: Obfuscator().reveal(key: key), handleNotificationAction: notificationReceived, settings: [kOSSettingsKeyAutoPrompt: false])
		OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
		OneSignal.promptForPushNotifications(userResponse: { _ in })
	}
}

extension PushNotification {
	func updateDatabase(openURL url: String?) {
		var images: [String] = []
		API().getPosts(page: 0) { post in
			DispatchQueue.main.async {
				guard let post = post else {
					// Prefetch images to be able to sent to Apple Watch
					let urls = images.compactMap { URL(string: $0) }
					let prefetcher = ImagePrefetcher(urls: urls)
					prefetcher.start()

					return
				}

				if let url = url, post.link == url {
					self.showDetailController(with: url)
				}

				images.append(post.artworkURL)
				CoreDataStack.shared.save(post: post)
			}
		}
	}

	func showDetailController(with link: String) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let controller = storyboard.instantiateViewController(withIdentifier: "detailController") as? PostsDetailViewController else {
			return
		}
		CoreDataStack.shared.links { links in
			prepareDetailController(controller, using: links, compare: link)
			UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true)
		}
	}
}
