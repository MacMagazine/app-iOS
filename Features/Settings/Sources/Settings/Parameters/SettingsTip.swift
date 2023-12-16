import CommonLibrary
import SwiftUI
import TipKit

enum SettingsTips: TipType {
	case subscriptions
	case appearance
	case notifications
	case about

	@available(iOS 17, *)
	private static var appearanceTip: AppearanceTip { AppearanceTip() }

	@available(iOS 17, *)
	private static var subscriptionsTip: SubscriptionsTip { SubscriptionsTip() }

	@available(iOS 17, *)
	private static var notificationsTip: PushNotificationTip { PushNotificationTip() }

	@available(iOS 17, *)
	private static var aboutTip: AboutTip { AboutTip() }
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

				case .notifications:
					TipView(Self.notificationsTip, arrowEdge: .bottom)

				case .about:
					TipView(Self.aboutTip, arrowEdge: .bottom)
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
			case .notifications: Self.notificationsTip.invalidate(reason: .actionPerformed)
			case .about: Self.aboutTip.invalidate(reason: .actionPerformed)
			}
		}
	}

	func show() {
		if #available(iOS 17, *) {
			switch self {
			case .appearance: AppearanceTip.isActive = true
			case .subscriptions: SubscriptionsTip.isActive = true
			case .notifications: PushNotificationTip.isActive = true
			case .about: AboutTip.isActive = true
			}
		}
	}
}
