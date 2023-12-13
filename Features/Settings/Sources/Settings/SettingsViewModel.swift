import Combine
import CommonLibrary
import CoreData
import CoreLibrary
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

	func accessibilityText(selected: Bool) -> String {
		switch self {
		case .normal: "Ícone do aplicativo com fundo branco.\(selected ? " Selecionado." : "")"
		case .alternative: "Ícone do aplicativo com fundo azul.\(selected ? " Selecionado." : "")"
		case .normalInverted: "Ícone azul do aplicativo com fundo preto.\(selected ? " Selecionado." : "")"
		case .alternativeInverted: "Ícone claro do aplicativo com fundo preto.\(selected ? " Selecionado." : "")"
		}
	}
}

public enum ColorScheme: Int {
	case light = 0
	case dark = 1
	case system = 2

	public var colorScheme: SwiftUI.ColorScheme? {
		switch self {
		case .light: .light
		case .dark: .dark
		case .system: nil
		}
	}

	func accessibilityText(selected: Bool) -> String {
		switch self {
		case .light: "Forçar modo claro para o aplicativo.\(selected ? " Selecionado." : "")"
		case .dark: "Forçar modo escuro para o aplicativo.\(selected ? " Selecionado." : "")"
		case .system: "Usar o modo definido pelo sistema para o aplicativo.\(selected ? " Selecionado." : "")"
		}
	}
}

public class SettingsViewModel: ObservableObject {
	@Published var icon: IconType = .normal
	@Published public var mode: ColorScheme = .light
	@Published public var isPresentingLoginPatrao = false
	@Published public var isPatrao = false
	@Published public var subscriptionValid = false

	private var cancellables: Set<AnyCancellable> = []

	public let mainContext: NSManagedObjectContext
	let storage: Database

	public init() {
		self.storage = Database(db: "SettingsModel",
								resource: Bundle.module.url(forResource: "SettingsModel", withExtension: "momd"))
		self.mainContext = self.storage.mainContext

		observeLoginStatus()
	}
}

extension SettingsViewModel {
	private func observeLoginStatus() {
		$isPatrao
			.removeDuplicates()
			.sink { [weak self] status in
				self?.storage.update(patrao: status)
			}
			.store(in: &cancellables)
	}
}

extension SettingsViewModel {
	@MainActor
	func setSettings() async {
		icon = await storage.appIcon
		mode = await storage.mode
		isPatrao = await storage.patrao

		Analytics.log(settings: [
			"icon": icon.rawValue as NSObject,
			"mode": mode.rawValue as NSObject,
			"patrao": isPatrao as NSObject,
		])
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

	@MainActor
	func change(_ mode: ColorScheme) async {
		storage.update(mode: mode)
	}
}
