import SwiftUI

struct PlainButtonTextStyle: ViewModifier {
	let color: Color
	let font: Font

	func body(content: Content) -> some View {
		content
			.font(font.weight(.bold))
			.foregroundColor(color)
			.padding(8)
	}
}

extension Text {
    @MainActor
    func plain(color: Color = .primary,
               font: Font = .caption) -> some View {
		modifier(PlainButtonTextStyle(color: color, font: font))
	}
}
