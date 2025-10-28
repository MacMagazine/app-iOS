import Foundation
import SwiftData

enum IconType: String, CaseIterable, Codable {
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
