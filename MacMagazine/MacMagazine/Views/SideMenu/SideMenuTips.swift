import CommonLibrary
import SwiftUI
import TipKit

enum SideMenuTips: TipType {
	case subscriptions
	case posts
	case settings
	case about

	@available(iOS 17, *)
	private static var subscriptionsTip: SubscriptionsTip { SubscriptionsTip() }

	@available(iOS 17, *)
	private static var postsTip: PostsTip { PostsTip() }

	@available(iOS 17, *)
	private static var settingsTip: OptionsTip { OptionsTip() }

	@available(iOS 17, *)
	private static var aboutTip: AboutTip { AboutTip() }
}

extension SideMenuTips {
	@ViewBuilder
	func tipView(with theme: ThemeColor) -> some View {
		if #available(iOS 17, *) {
			Group {
				switch self {
				case .subscriptions:
					TipView(Self.subscriptionsTip, arrowEdge: .bottom)

				case .posts:
					TipView(Self.postsTip, arrowEdge: .bottom)

				case .settings:
					TipView(Self.settingsTip, arrowEdge: .bottom)

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
			case .subscriptions: Self.subscriptionsTip.invalidate(reason: .actionPerformed)
			case .posts: Self.postsTip.invalidate(reason: .actionPerformed)
			case .settings: Self.settingsTip.invalidate(reason: .actionPerformed)
			case .about: Self.aboutTip.invalidate(reason: .actionPerformed)
			}
		}
	}

	func show() {
		if #available(iOS 17, *) {
			switch self {
			case .subscriptions: SubscriptionsTip.isActive = true
			case .posts: PostsTip.isActive = true
			case .settings: OptionsTip.isActive = true
			case .about: AboutTip.isActive = true
			}
		}
	}
}
