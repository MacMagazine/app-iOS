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
        let key: [UInt8] = [37, 68, 65, 114, 92, 85, 93, 84, 76, 70, 82, 120, 100, 98, 86, 91, 80, 83, 89, 121, 69, 66, 38, 72, 91, 92, 86, 88, 18, 7, 127, 106, 120, 91, 14, 83]

        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_VERBOSE)
        OneSignal.initWithLaunchOptions(options)
        OneSignal.setAppId(Obfuscator().reveal(key: key))

		OneSignal.promptForPushNotifications(userResponse: { _ in })

        let notifWillShowInForegroundHandler: OSNotificationWillShowInForegroundBlock = { notification, completion in
            logD("Received Notification: \(notification.notificationId ?? "no id")")
            logD("launchURL: \(notification.launchURL ?? "no launch url")")
            logD("content_available = \(notification.contentAvailable)")

            self.updateDatabase(for: nil)
            completion(nil)
        }

        OneSignal.setNotificationWillShowInForegroundHandler(notifWillShowInForegroundHandler)

        let notificationOpenedBlock: OSNotificationOpenedBlock = { result in
            // This block gets called when the user reacts to a notification received
            let notification: OSNotification = result.notification
            guard let additionalData = notification.additionalData,
                  let url = additionalData as? [String: String] else {
                return
            }

            logD("Message: \(notification.body ?? "empty body")")
            logD("additionalData: \(additionalData)")

            (UIApplication.shared.delegate as? AppDelegate)?.widgetSpotlightPost = url["url"]
        }

        OneSignal.setNotificationOpenedHandler(notificationOpenedBlock)
    }
}

extension PushNotification {
	func updateDatabase(for url: String?) {
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
				images.append(post.artworkURL)
				CoreDataStack.shared.save(post: post)

				if let url = url,
					post.link == url ||
						post.shortURL == url {
					delay(0.1) {
						showDetailController(with: post.link)
					}
				}
			}
		}
	}
}
