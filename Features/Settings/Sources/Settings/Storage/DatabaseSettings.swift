import CoreData
import CoreLibrary
import Foundation

extension Database {
	private var items: [Settings]? {
		get async {
			return try? await self.get(from: "Settings") as? [Settings]
		}
	}

	var appIcon: IconType {
		get async {
			guard let items = await items else { return .normal }
			return IconType(rawValue: items.first?.icon ?? "") ?? .normal
		}
	}

	var mode: ColorScheme {
		get async {
			guard let items = await items else { return .light }
			return ColorScheme(rawValue: Int(items.first?.mode ?? 0)) ?? .light
		}
	}

	var patrao: Bool {
		get async {
			guard let items = await items else { return false }
			return items.first?.patrao ?? false
		}
	}

	var expirationDate: Date? {
		get async {
			guard let items = await items else { return nil }
			return items.first?.expiration
		}
	}

	var notification: PushPreferences {
		get async {
			guard let items = await items else { return .all }
			return PushPreferences(rawValue: items.first?.notification ?? "") ?? .all
		}
	}

	func update(appIcon: IconType? = nil,
				mode: ColorScheme? = nil,
				patrao: Bool? = nil,
				expiration: Date? = nil,
				notification: String? = nil) {
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
				if let patrao {
					item.patrao = patrao
				}
				if let expiration {
					item.expiration = expiration
				}
				if let notification {
					item.notification = notification
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
			if let patrao {
				item.patrao = patrao
			}
			if let expiration {
				item.expiration = expiration
			}
			if let notification {
				item.notification = notification
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
