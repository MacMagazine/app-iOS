//
//  Share.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 15/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

struct Share {
	func present<T>(at location: T?, using items: [Any]) {
		let safari = UIActivityExtensions(title: "Abrir no Safari", image: UIImage(named: "safari")) { items in
			for item in items {
				guard let url = URL(string: "\(item)") else {
					continue
				}
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}
		}

		let chrome = UIActivityExtensions(title: "Abrir no Chrome", image: UIImage(named: "chrome")) { items in
			for item in items {
				guard let url = URL(string: "\(item)".replacingOccurrences(of: "http", with: "googlechrome")) else {
					continue
				}
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}
		}
		var activities = [safari]
		if let url = URL(string: "googlechrome://"),
			UIApplication.shared.canOpenURL(url) {
			activities.append(chrome)
		}

		let activityVC = UIActivityViewController(activityItems: items, applicationActivities: activities)
		if let ppc = activityVC.popoverPresentationController {
			if location != nil {
				if let view = location as? UIView {
					ppc.sourceView = view
				}
				if let button = location as? UIBarButtonItem {
					ppc.barButtonItem = button
				}
			}
		}
		UILabel.appearance().textColor = .black
		Settings().applyLightTheme()
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController?.present(activityVC, animated: true)
	}
}
