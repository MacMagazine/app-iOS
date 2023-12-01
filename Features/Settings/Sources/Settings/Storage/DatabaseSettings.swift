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

	func update(appIcon: IconType) {
		Task {
			guard let items = try? await self.get(from: "Settings") as? [Settings],
				  let item = items.first else {
				let item = Settings(context: self.mainContext)
				item.icon = appIcon.rawValue
				await saveUsingMainActor()
				return
			}
			item.icon = appIcon.rawValue
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
