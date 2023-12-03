import CommonLibrary
import SwiftUI
import TipKit

enum SettingsTips: TipType {
	case appIcon
	case subscriptions

	@available(iOS 17, *)
	private static var appIconTip: AppIconTip { AppIconTip() }

	@available(iOS 17, *)
	private static var subscriptionsTip: SubscriptionsTip { SubscriptionsTip() }
}

extension SettingsTips {
	@ViewBuilder
	func tipView(with theme: ThemeColor) -> some View {
		if #available(iOS 17, *) {
			Group {
				switch self {
				case .appIcon:
					TipView(Self.appIconTip, arrowEdge: .bottom)

				case .subscriptions:
					TipView(Self.subscriptionsTip, arrowEdge: .bottom)
				}
			}
			.style(theme: theme)
		}
	}

	func invalidate() {
		if #available(iOS 17, *) {
			switch self {
			case .appIcon: Self.appIconTip.invalidate(reason: .actionPerformed)
			case .subscriptions: Self.subscriptionsTip.invalidate(reason: .actionPerformed)
			}
		}
	}

	func show() {
		if #available(iOS 17, *) {
			switch self {
			case .appIcon: AppIconTip.isActive = true
			case .subscriptions: SubscriptionsTip.isActive = true
			}
		}
	}
}

//	_ = content.popoverTip(tip)

@available(iOS 17, *)
struct AppIconTip: Tip {
	@Parameter
	static var isActive: Bool = true

	var title: Text { Text("Escolha o ícone do seu app") }
	var message: Text? { Text("Customize o app para melhor representar seu jeito.") }

	var rules: [Rule] = [
		#Rule(Self.$isActive) { $0 == true }
	]

	var actions: [Action] {
		SettingsTips.appIcon.add { tip in
			(tip as? SettingsTips)?.show()
		}
	}
}

@available(iOS 17, *)
struct SubscriptionsTip: Tip {
	@Parameter
	static var isActive: Bool = false

	var title: Text { Text("Remover propagandas") }
	var message: Text? { Text("Navegue pelo app sem propagandas - ou, alternativamente, use seu login de patrão.") }

	var rules: [Rule] = [
		#Rule(Self.$isActive) { $0 == true }
	]

	var actions: [Action] {
		SettingsTips.subscriptions.add { tip in
			(tip as? SettingsTips)?.show()
		}
	}
}
