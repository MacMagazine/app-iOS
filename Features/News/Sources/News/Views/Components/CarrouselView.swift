import CommonLibrary
import CoreData
import SwiftUI
import UIComponentsLibrary

public struct CarrouselView: View {
	private struct NewsToShow {
		let title: String
		let url: String
	}

	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: NewsViewModel
	@FetchRequest var news: FetchedResults<News>

	@State private var newsToShow = NewsToShow(title: "", url: "")

	private var filter: NewsViewModel.Category
	private var width: CGFloat
	private var limit: Int

	public init(filter: NewsViewModel.Category,
				fit width: CGFloat,
				limit: Int = 5) {
		let request: NSFetchRequest<News> = News.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(keyPath: \News.pubDate, ascending: false)]
		_news = FetchRequest(fetchRequest: request)

		self.filter = filter
		self.width = min(360, width * 0.82)
		self.limit = limit
	}

	public var body: some View {
		ScrollView(.horizontal) {
			HStack(spacing: filter.spacing) {
				ForEach(news.filter { $0.allCategories?.contains(filter.rawValue) ?? true }.prefix(limit), id: \.self) { object in
					show(content: object)
						.frame(width: width)
						.clipped()
				}
			}
		}
		.fullScreenCover(isPresented: Binding(get: { !newsToShow.url.isEmpty },
											  set: { _, _ in })) {
			Webview(title: newsToShow.title,
					url: newsToShow.url,
					isPresenting: Binding(get: { !newsToShow.url.isEmpty },
										  set: { _, _ in newsToShow = NewsToShow(title: "", url: "") }))
		}
	}
}

extension CarrouselView {
	@ViewBuilder
	private func show(content object: News) -> some View {
		Button(action: {
			newsToShow = NewsToShow(title: object.title ?? "", url: object.shortURL ?? "")
		}, label: {
			CardView(object: CardData(style: filter.style,
									  title: object.title,
									  creator: object.creator,
									  pubDate: object.pubDate(format: filter.dateFormat),
									  artworkURL: object.artworkURL,
									  width: filter.width ?? width,
									  height: filter.height,
									  aspectRatio: filter.aspectRatio))
		})
	}
}
