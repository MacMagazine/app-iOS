import SwiftUI

struct TitleView: View {
	private let title: String
	private let color: Color
	private let lineLimit: Int

	init?(title: String?,
		  color: Color? = nil,
		  lineLimit: Int = 4) {
		guard let title = title else { return nil }
		self.title = title
		self.color = color ?? .white
		self.lineLimit = lineLimit
	}

	public var body: some View {
		HStack {
			Text(title)
				.foregroundStyle(color)
				.bold()
				.lineLimit(lineLimit)
				.multilineTextAlignment(.leading)
			Spacer()
		}
	}
}

#Preview {
	TitleView(title: "MacMagazine")
}
