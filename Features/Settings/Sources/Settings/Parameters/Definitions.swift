import SwiftUI
import UIComponentsLibrary

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

