import CommonLibrary
import SwiftUI
import TipKit

enum SettingsTips: TipType {
	case appearance
	case subscriptions

	@available(iOS 17, *)
	private static var appearanceTip: AppearanceTip { AppearanceTip() }

	@available(iOS 17, *)
	private static var subscriptionsTip: SubscriptionsTip { SubscriptionsTip() }
}

extension SettingsTips {
	@ViewBuilder
	func tipView(with theme: ThemeColor) -> some View {
		if #available(iOS 17, *) {
			Group {
				switch self {
				case .appearance:
					TipView(Self.appearanceTip, arrowEdge: .bottom)

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
			case .appearance: Self.appearanceTip.invalidate(reason: .actionPerformed)
			case .subscriptions: Self.subscriptionsTip.invalidate(reason: .actionPerformed)
			}
		}
	}

	func show() {
		if #available(iOS 17, *) {
			switch self {
			case .appearance: AppearanceTip.isActive = true
			case .subscriptions: SubscriptionsTip.isActive = true
			}
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
