import CommonLibrary
import SwiftUI
import TipKit

enum SettingsTips: TipType {
	case notifications
	case appearance

	@available(iOS 17, *)
	private static var appearanceTip: AppearanceTip { AppearanceTip() }

	@available(iOS 17, *)
	private static var notificationsTip: PushNotificationTip { PushNotificationTip() }
}

extension SettingsTips {
	@ViewBuilder
	func tipView(with theme: ThemeColor) -> some View {
		if #available(iOS 17, *) {
			Group {
				switch self {
				case .appearance:
					TipView(Self.appearanceTip, arrowEdge: .bottom)

				case .notifications:
					TipView(Self.notificationsTip, arrowEdge: .bottom)
				}
			}
			.style(theme: theme)
		}
	}

	func invalidate() {
		if #available(iOS 17, *) {
			switch self {
			case .appearance: Self.appearanceTip.invalidate(reason: .actionPerformed)
			case .notifications: Self.notificationsTip.invalidate(reason: .actionPerformed)
			}
		}
	}

	func show() {
		if #available(iOS 17, *) {
			switch self {
			case .appearance: AppearanceTip.isActive = true
			case .notifications: PushNotificationTip.isActive = true
			}
		}
	}
}
// MARK: -

@available(iOS 17, *)
struct AppearanceTip: Tip {
	@Parameter
	static var isActive: Bool = false

	var title: Text { Text("Seu app, seu jeito") }
	var message: Text? { Text("Escolha a aparência do seu app, incluido modo escuro e ícone do app.") }

	var rules: [Rule] = [
		#Rule(Self.$isActive) { $0 == true }
	]

	var actions: [Action] {
		SettingsTips.appearance.add { tip in
			(tip as? SettingsTips)?.show()
		}
	}
}

@available(iOS 17, *)
struct PushNotificationTip: Tip {
	@Parameter
	static var isActive: Bool = true

	var title: Text { Text("Push Notifications") }
	var message: Text? { Text("Receba notificações toda vez que um novo post for publicado. Escolha entre qualquer novo post ou somente os posts em Destaque.") }

	var rules: [Rule] = [
		#Rule(Self.$isActive) { $0 == true }
	]

	var actions: [Action] {
		SettingsTips.notifications.add { tip in
			(tip as? SettingsTips)?.show()
		}
	}
}
