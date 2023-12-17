import CommonLibrary
import SwiftUI
import TipKit

public enum SettingsTips: TipType {
	case notifications
	case appearance

	@available(iOS 17, *)
	private static var appearanceTip: AppearanceTip { AppearanceTip() }

	@available(iOS 17, *)
	private static var notificationsTip: PushNotificationTip { PushNotificationTip() }
}

extension SettingsTips {
	@ViewBuilder
	public func tipView(with theme: ThemeColor) -> some View {
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

	public func invalidate() {
		if #available(iOS 17, *) {
			switch self {
			case .appearance: Self.appearanceTip.invalidate(reason: .actionPerformed)
			case .notifications: Self.notificationsTip.invalidate(reason: .actionPerformed)
			}
		}
	}

	public func show() {
		if #available(iOS 17, *) {
			switch self {
			case .appearance: AppearanceTip.isActive = true
			case .notifications: PushNotificationTip.isActive = true
			}
		}
	}
}
