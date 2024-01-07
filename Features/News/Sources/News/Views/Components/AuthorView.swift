import SwiftUI

struct AuthorView: View {
	private let author: String?
	private let date: String?
	private let color: Color

	init?(author: String?,
		  date: String?,
		  color: Color? = nil) {
		if author == nil && date == nil {
			return nil
		}
		self.author = author
		self.date = date
		self.color = color ?? .white
	}

	public var body: some View {
		HStack {
			if let author = author {
				Text(author)
			}
			if let date = date {
				Text(date).layoutPriority(1)
			}
			Spacer()
		}
		.foregroundColor(color)
		.lineLimit(1)
		.font(.subheadline)
	}
}

#Preview {
	AuthorView(author: "MacMagazine", date: "10.10.69")
}
