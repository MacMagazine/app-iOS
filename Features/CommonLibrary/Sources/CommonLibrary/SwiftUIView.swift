import SwiftUI

public struct HeaderView: View {
	private let title: String
	private let theme: ThemeColor
	private let action: () -> Void

	public init(title: String,
				theme: ThemeColor,
				action: @escaping () -> Void) {
		self.title = title
		self.theme = theme
		self.action = action
	}

	public var body: some View {
		HStack {
			Text(title)
				.font(.largeTitle)
				.foregroundColor(theme.text.terciary.color)

			Spacer()

			Button(action: { action() },
				   label: {
				Image(systemName: "arrow.right.circle.fill")
					.tint(theme.tertiary.background.color)
					.imageScale(.large)
			})
		}
    }
}

#Preview {
	HeaderView(title: "Title", theme: ThemeColor()) {}
}
