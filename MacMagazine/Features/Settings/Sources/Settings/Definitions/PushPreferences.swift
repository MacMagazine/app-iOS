import Foundation

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
