import Foundation
import SwiftUI
import UIComponentsLibrary

public struct ThemeColor: Themeable {
	public let main = MainColor(background: "MMGrey6",
								navigation: "MMBlack90",
								tint: "MMBlueWhite",
								shadow: "")

	public let secondary = SecondaryColor(background: "MMWhiteBlack")
	public let tertiary = SecondaryColor(background: "MMDarkGreyWhite")

	public let text = TextColor(primaryTab: "",
								primary: "MMBlueWhite",
								secondary: "MMWhiteGrey6",
								terciary: "MMLessDarkGreyWhite",
								error: "")

	public let button = ButtonColor(primary: "MMBlue",
									secondary: "MMBlueWhite",
									terciary: "",
									destructive: "TabascoDracula")

    public init() {}
}

extension String {
	public var color: Color? { Color(self, bundle: .module) }
}

extension EnvironmentValues {
    @Entry public var theme: ThemeColor = ThemeColor()
}
