import SwiftUI

public struct PlainButtonTextStyle: ViewModifier {
	let color: Color

	public init(color: Color) {
		self.color = color
	}

	public func body(content: Content) -> some View {
		content
			.font(.caption.weight(.bold))
			.foregroundColor(color)
			.padding(8)
	}
}

extension Text {
	public func plain(color: Color = .primary) -> some View {
		modifier(PlainButtonTextStyle(color: color))
	}
}
