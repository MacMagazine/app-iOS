import CommonLibrary
import CoreData
import SwiftUI
import UIComponentsLibrary

struct NewsFullView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: NewsViewModel
	@FetchRequest var news: FetchedResults<News>

	private let filter: NewsViewModel.Category
	private let limit: Int?

	init(filter: NewsViewModel.Category,
		 limit: Int? = nil) {
		let request: NSFetchRequest<News> = News.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(keyPath: \News.pubDate, ascending: false)]
		_news = FetchRequest(fetchRequest: request)

		self.filter = filter
		self.limit = limit
	}

	var body: some View {
		LazyVGrid(columns: [GridItem(.adaptive(minimum: 280),
									 alignment: .top)]) {
			ForEach(news.filter { filter.filter(source: $0.allCategories) }.prefix(limit ?? news.count), id: \.self) { object in
				Button(action: {
					viewModel.newsToShow = NewsToShow(title: object.title ?? "", url: object.shortURL ?? "", favorite: object.favorite)
				}, label: {
					if filter.style == .highlight {
						GeometryReader { geo in
							CardView(object: CardData(style: filter.style,
													  title: object.title,
													  creator: object.creator,
													  pubDate: object.pubDate(format: filter.dateFormat),
													  artworkURL: object.artworkURL,
													  width: filter.width ?? geo.size.width,
													  height: filter.height,
													  aspectRatio: filter.aspectRatio))
						}
						.aspectRatio(filter.aspectRatio, contentMode: .fit)
					} else {
						CardView(object: CardData(style: filter.style,
												  title: object.title,
												  creator: object.creator,
												  pubDate: object.pubDate(format: filter.dateFormat),
												  artworkURL: object.artworkURL,
												  width: filter.width ?? .infinity,
												  height: filter.height,
												  aspectRatio: filter.aspectRatio))
					}
				})
			}
		}
	}
}
