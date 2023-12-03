import CoreData
import CoreLibrary
import Foundation

extension Database {
	var appIcon: IconType {
		get async {
			guard let items = try? await self.get(from: "Settings") as? [Settings] else {
				return .normal
			}
			return IconType(rawValue: items.first?.icon ?? "") ?? .normal
		}
	}

	var mode: ColorScheme {
		get async {
			guard let items = try? await self.get(from: "Settings") as? [Settings] else {
				return .light
			}
			return ColorScheme(rawValue: Int(items.first?.mode ?? 0)) ?? .light
		}
	}

	func update(appIcon: IconType? = nil,
				mode: ColorScheme? = nil) {
		Task {
			guard let items = try? await self.get(from: "Settings") as? [Settings],
				  let item = items.first else {
				let item = Settings(context: self.mainContext)
				if let appIcon {
					item.icon = appIcon.rawValue
				}
				if let mode {
					item.mode = Int16(mode.rawValue)
				}
				await saveUsingMainActor()
				return
			}
			if let appIcon {
				item.icon = appIcon.rawValue
			}
			if let mode {
				item.mode = Int16(mode.rawValue)
			}
			await saveUsingMainActor()
		}
	}
}

extension Database {
	func saveUsingMainActor() async {
		await MainActor.run {
			try? self.save()
		}
	}
}
