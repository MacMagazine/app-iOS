import Foundation
import SwiftUI
import UIComponentsLibrary

public struct Bubble {
	let background: String
	let text: String
}

public protocol AppColor {
	var user: Bubble { get }
	var assistant: Bubble { get }
	var tip: TipConfig { get }
}

public typealias ThemeColor = Themeable & AppColor

public struct ThemeColorImplementation: ThemeColor {
	public let main = MainColor(background: "MMWhiteGrey6",
								navigation: "MMBlack90",
								tint: "MMBlueWhite",
								shadow: "")

	public let secondary = SecondaryColor(background: "Secondary")
	public let tertiary = SecondaryColor(background: "Tertiary")

	public let text = TextColor(primaryTab: "",
								primary: "MMBlueWhite",
								secondary: "MMWhiteGrey6",
								terciary: "MMLessDarkGreyWhite",
								error: "")

	public let button = ButtonColor(primary: "MMBlue",
									secondary: "",
									terciary: "",
									destructive: "")

	public let tip = TipConfig(background: "MMBlue",
							   text: "MMBlack90")

	public let user = Bubble(background: "",
							 text: "")

	public let assistant = Bubble(background: "",
								  text: "")

	public init() {}
}

extension String {
	public var color: Color? {
		return Color(self, bundle: .module)
	}
}

struct ThemeEnvironmentKey: EnvironmentKey {
	static public var defaultValue: ThemeColor = ThemeColorImplementation()
}

extension EnvironmentValues {
	public var theme: ThemeColor {
		get { self[ThemeEnvironmentKey.self] }
		set { self[ThemeEnvironmentKey.self] = newValue }
	}
}
