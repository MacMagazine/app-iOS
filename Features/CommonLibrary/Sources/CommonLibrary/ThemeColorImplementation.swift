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
								shadow: "Blue")

	public let secondary = SecondaryColor(background: "Secondary")
	public let tertiary = SecondaryColor(background: "Tertiary")

	public let text = TextColor(primaryTab: "SharkGallery",
								primary: "MMBlueWhite",
								secondary: "MMWhiteGrey6",
								terciary: "Purple",
								error: "TabascoDracula")

	public let button = ButtonColor(primary: "Purple",
									secondary: "Pink",
									terciary: "Blue1",
									destructive: "TabascoDracula")

	public let tip = TipConfig(background: "MMBlue",
							   text: "MMBlack90")

	public let user = Bubble(background: "Secondary",
							 text: "Gray")

	public let assistant = Bubble(background: "Blue",
								  text: "Blue")

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

