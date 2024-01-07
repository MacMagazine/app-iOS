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
	let aspectRatio: CGFloat
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
			ImageView(style: .fullWidth, url: URL(string: object.artworkURL ?? ""), width: object.width, aspectRatio: object.aspectRatio)
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
			ImageView(style: .fullWidth, url: URL(string: object.artworkURL ?? ""), width: object.width, aspectRatio: object.aspectRatio)
			Spacer()
			TitleView(title: object.title, color: theme.text.primary.color)
			AuthorView(author: object.creator, date: object.pubDate, color: theme.text.terciary.color)
		}.padding(.horizontal)
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
		VStack {
			ImageView(url: URL(string: object.artworkURL ?? ""), width: object.width, aspectRatio: object.aspectRatio)
			TitleView(title: object.title, color: theme.text.primary.color)
		}.padding(.horizontal)
	}
}

#Preview {
	CardView(object: CardData(style: .imageLast, title: "Title", creator: "Author", pubDate: "", artworkURL: "", width: 1, aspectRatio: 1))
}
