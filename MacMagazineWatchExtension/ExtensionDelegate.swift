//
//  ExtensionDelegate.swift
//  MacMagazineWatch Extension
//
//  Created by Cassio Rossi on 08/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Foundation
import UserNotifications
import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

	func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
		// Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
		for task in backgroundTasks {
			// Use a switch statement to check the task type
			switch task {
			case let backgroundTask as WKApplicationRefreshBackgroundTask:
				// Be sure to complete the background task once you’re done.
				reloadComplicationData(backgroundTask: backgroundTask)
			case let snapshotTask as WKSnapshotRefreshBackgroundTask:
				// Snapshot tasks have a unique completion call, make sure to set your expiration date
				snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
			case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
				// Be sure to complete the connectivity task once you’re done.
				connectivityTask.setTaskCompletedWithSnapshot(false)
			case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
				// Be sure to complete the URL session task once you’re done.
				urlSessionTask.setTaskCompletedWithSnapshot(false)
			case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
				// Be sure to complete the relevant-shortcut task once you're done.
				relevantShortcutTask.setTaskCompletedWithSnapshot(false)
			case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
				// Be sure to complete the intent-did-run task once you're done.
				intentDidRunTask.setTaskCompletedWithSnapshot(false)
			default:
				// make sure to complete unhandled task types
				task.setTaskCompletedWithSnapshot(false)
			}
		}
	}

	func reloadComplicationData(backgroundTask: WKApplicationRefreshBackgroundTask) {
		backgroundTask.setTaskCompletedWithSnapshot(false)
		reloadData()

		let later = Date(timeIntervalSinceNow: 60 * 60)	// every hour
		WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: later, userInfo: nil) { _ in }
	}

	func reloadData() {
		let complicationsController = ComplicationController()
		complicationsController.reloadData()
	}

	func applicationDidFinishLaunching() {
		Task {
			do {
				let success = try await UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert])
				guard success else { return }

				await MainActor.run {
					WKExtension.shared().registerForRemoteNotifications()
				}
			} catch {
				print(error.localizedDescription)
			}
		}
	}

	func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
		let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
		OneSignalPushNotification.addDevice(token: token)
	}
}

class OneSignalPushNotification: NSObject {
	static func addDevice(token: String) {
		do {
			guard let url = URL(string: "https://onesignal.com/api/v1/players") else { return }
			let headers = ["accept": "application/json",
						   "Content-Type": "application/json"]

			let key: [UInt8] = [37, 68, 65, 114, 92, 85, 93, 84, 76, 70, 82, 120, 100, 98, 86, 91, 80, 83, 89, 121, 69, 66, 38, 72, 91, 92, 86, 88, 18, 7, 127, 106, 120, 91, 14, 83]

			let parameters: [String: Any] = ["app_id": Obfuscator().reveal(key: key),
											 "device_type": 0,
											 "identifier": token]

			let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

			Task {
				var request = URLRequest(url: url)
				request.httpMethod = "POST"
				request.allHTTPHeaderFields = headers
				request.httpBody = postData

				_ = try await URLSession.shared.data(for: request)
			}
		} catch {
			logE(error.localizedDescription)
		}
	}
}
