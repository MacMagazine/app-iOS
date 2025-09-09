import SwiftUI
import UIComponentsLibrary

enum IconType: String, CaseIterable {
	case normal
	case alternative

	var appIcon: String {
		switch self {
		case .normal: "mm_icon_normal"
		case .alternative: "mm_icon_inverted"
		}
	}

	func accessibilityText(selected: Bool) -> String {
		switch self {
		case .normal: "Ícone do aplicativo com fundo branco.\(selected ? " Selecionado." : "")"
		case .alternative: "Ícone do aplicativo com fundo azul.\(selected ? " Selecionado." : "")"
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

enum PushPreferences: String {
	case featured = "featured_posts"
	case all = "all_posts"

	func accessibilityText(selected: Bool) -> String {
		switch self {
		case .all: "Receber notificações para todos os posts.\(selected ? " Selecionado." : "")"
		case .featured: "Receber notificações somente para posts em destaque.\(selected ? " Selecionado." : "")"
		}
	}
}

public enum Cache {
	case readAll
	case keepFavoritesAndStatus
	case keepStatus
	case keepFavorites
	case cleanImages
	case cleanAll
}
