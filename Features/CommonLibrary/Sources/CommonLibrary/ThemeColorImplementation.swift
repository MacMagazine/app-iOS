import Foundation
import SwiftUI
import UIComponentsLibrary

public struct Bubble {
	let background: Color
	let text: Color
}

public protocol AppColor {
	var user: Bubble { get }
	var assistant: Bubble { get }
}

public typealias ThemeColor = Themeable & AppColor

public struct ThemeColorImplementation: ThemeColor {
	public let main = MainColor(background: "MMWhiteGrey6",
								navigation: "MainDark",
								tint: "MMBlueWhite",
								shadow: "Blue")

	public let secondary = SecondaryColor(background: "Secondary")
	public let tertiary = SecondaryColor(background: "Tertiary")

	public let text = TextColor(primaryTab: "SharkGallery",
								primary: "MMBlueWhite",
								secondary: "Blue",
								terciary: "Purple",
								error: "TabascoDracula")

	public let button = ButtonColor(primary: "Purple",
									secondary: "Pink",
									terciary: "Blue1",
									destructive: "TabascoDracula")

	public let user = Bubble(background: Color("Secondary", bundle: .module),
							 text: Color("Gray", bundle: .module))

	public let assistant = Bubble(background: Color("Blue", bundle: .module),
								  text: Color.white)

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

