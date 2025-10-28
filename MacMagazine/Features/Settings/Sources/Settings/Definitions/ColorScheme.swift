import SwiftData
import SwiftUI

public enum ColorScheme: Int, Codable {
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
