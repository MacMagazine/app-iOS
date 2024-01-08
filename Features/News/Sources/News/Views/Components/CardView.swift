import CommonLibrary
import SwiftUI
import UIComponentsLibrary

struct CardData {
	enum Style {
		case imageFirst
		case imageLast
		case highlight
		case simple
	}

	let style: Style
	let title: String?
	let creator: String?
	let pubDate: String
	let artworkURL: String?
	let width: CGFloat
	let height: CGFloat
	let aspectRatio: CGFloat

	init(style: Style,
		 title: String?,
		 creator: String?,
		 pubDate: String,
		 artworkURL: String?,
		 width: CGFloat = .infinity,
		 height: CGFloat = .infinity,
		 aspectRatio: CGFloat) {
		self.style = style
		self.title = title
		self.creator = creator
		self.pubDate = pubDate
		self.artworkURL = artworkURL
		self.width = width
		self.height = height
		self.aspectRatio = aspectRatio
	}
}

struct CardView: View {
	@Environment(\.theme) private var theme: ThemeColor
	private let object: CardData

	init(object: CardData) {
		self.object = object
	}

	var body: some View {
		switch object.style {
		case .imageFirst: imageFirstView
		case .imageLast: imageLastView
		case .highlight: highlightView
		case .simple: simpleView
		}
	}
}

extension CardView {
	@ViewBuilder
	private var imageLastView: some View {
		VStack(spacing: 8) {
			TitleView(title: object.title, color: theme.text.terciary.color)
			AuthorView(author: object.creator, date: object.pubDate, color: theme.text.terciary.color)
			Spacer()
			ImageView(style: .fullWidth, url: URL(string: object.artworkURL ?? ""), height: object.height, aspectRatio: object.aspectRatio)
		}
		.padding()
		.background {
			Rectangle().fill(theme.secondary.background.color ?? .white)
				.cornerRadius(12, corners: .allCorners)
		}
	}

	@ViewBuilder
	private var imageFirstView: some View {
		VStack(spacing: 8) {
			ImageView(style: .fullWidth, url: URL(string: object.artworkURL ?? ""), height: object.height, aspectRatio: object.aspectRatio)
			Spacer()
			TitleView(title: object.title, color: theme.text.terciary.color)
			AuthorView(author: object.creator, date: object.pubDate, color: theme.text.terciary.color)
		}
		.padding()
		.background {
			Rectangle().fill(theme.secondary.background.color ?? .white)
				.cornerRadius(12, corners: .allCorners)
		}
	}

	@ViewBuilder
	private var highlightView: some View {
		ZStack {
			ImageView(url: URL(string: object.artworkURL ?? ""),
					  width: object.width,
					  aspectRatio: object.aspectRatio)

			VStack(spacing: 8) {
				Spacer()
				TitleView(title: object.title)
				AuthorView(author: object.creator, date: object.pubDate)
			}
			.shadow(color: .black, radius: 1)
			.padding([.horizontal, .bottom])
		}
	}

	@ViewBuilder
	private var simpleView: some View {
		HStack(spacing: 12) {
			ImageView(style: .followRatio, url: URL(string: object.artworkURL ?? ""), width: object.width, height: object.height, aspectRatio: object.aspectRatio)
			TitleView(title: object.title, color: theme.text.primary.color)
		}
	}
}

#Preview {
	CardView(object: CardData(style: .imageLast, title: "Title", creator: "Author", pubDate: "", artworkURL: "", aspectRatio: 1))
}
