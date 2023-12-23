import CoreData
import CoreLibrary
import Foundation

extension Database {
	private var items: [Settings]? {
		get async {
			return try? await self.get(from: "Settings", using: mainContext) as? [Settings]
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

	var postRead: Bool {
		get async {
			guard let items = await items else { return false }
			return items.first?.postRead ?? false
		}
	}

	var countOnBadge: Bool {
		get async {
			guard let items = await items else { return false }
			return items.first?.countOnBadge ?? false
		}
	}

	func update(appIcon: IconType? = nil,
				mode: ColorScheme? = nil,
				patrao: Bool? = nil,
				postRead: Bool? = nil,
				countOnBadge: Bool? = nil,
				expiration: Date? = nil,
				notification: String? = nil) {
		Task {
			guard let items = try? await self.get(from: "Settings", using: mainContext) as? [Settings],
				  let item = items.first else {
				let item = Settings(context: mainContext)
				if let appIcon {
					item.icon = appIcon.rawValue
				}
				if let mode {
					item.mode = Int16(mode.rawValue)
				}
				if let patrao {
					item.patrao = patrao
				}
				if let postRead {
					item.postRead = postRead
				}
				if let countOnBadge {
					item.countOnBadge = countOnBadge
				}
				if let expiration {
					item.expiration = expiration
				}
				if let notification {
					item.notification = notification
				}
				try? mainContext.save()
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
			if let postRead {
				item.postRead = postRead
			}
			if let countOnBadge {
				item.countOnBadge = countOnBadge
			}
			if let expiration {
				item.expiration = expiration
			}
			if let notification {
				item.notification = notification
			}
			try? mainContext.save()
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
