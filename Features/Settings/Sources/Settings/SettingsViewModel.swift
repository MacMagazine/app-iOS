import CoreData
import CoreLibrary
import Foundation
import SwiftUI

enum IconType: String, CaseIterable {
	case normal
	case alternative
	case normalInverted
	case alternativeInverted

	var appIcon: String {
		switch self {
		case .normal: "AppIcon-1"
		case .alternative: "AppIcon-2"
		case .normalInverted: "AppIcon-3"
		case .alternativeInverted: "AppIcon-4"
		}
	}
}

public class SettingsViewModel: ObservableObject {
	@Published var icon: IconType = .normal

	public let mainContext: NSManagedObjectContext
	let storage: Database

	public init() {
		self.storage = Database(db: "SettingsModel",
								resource: Bundle.module.url(forResource: "SettingsModel", withExtension: "momd"))
		self.mainContext = self.storage.mainContext
	}
}

extension SettingsViewModel {
	@MainActor
	func setSettings() async {
		icon = await storage.appIcon
	}
}

extension SettingsViewModel {
	@MainActor
	func change(_ icon: IconType) async {
		guard UIApplication.shared.supportsAlternateIcons else {
			return
		}

		do {
			try await UIApplication.shared.setAlternateIconName(icon.appIcon)
			storage.update(appIcon: icon)
			self.icon = icon
		} catch {
		}
	}
}
