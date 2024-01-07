import CommonLibrary
import CoreData
import SwiftUI
import UIComponentsLibrary

public struct NewsView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: NewsViewModel
	@FetchRequest var news: FetchedResults<News>

	public init() {
		let request: NSFetchRequest<News> = News.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(keyPath: \News.pubDate, ascending: false)]
		_news = FetchRequest(fetchRequest: request)
	}

	public var body: some View {
		VStack {
			HStack {
				Text("Últimas Notícias")
					.font(.largeTitle)
					.foregroundColor(theme.text.terciary.color)

				Spacer()

				Button(action: {},
					   label: {
					Text("ver mais".uppercased())
						.rounded(fill: theme.button.primary.color ?? .blue)
				})
			}

			ErrorView(message: viewModel.status.reason, theme: theme)
				.padding(.top)

			LazyVGrid(columns: [GridItem(.adaptive(minimum: 280),
										 alignment: .top)]) {
				ForEach(news.filter { !($0.allCategories?.contains(NewsViewModel.Category.highlights.rawValue) ?? true) }.prefix(8), id: \.self) { object in
					CardView(object: CardData(style: .imageLast,
											  title: object.title,
											  creator: object.creator,
											  pubDate: object.pubDate(format: .mmDateTime),
											  artworkURL: object.artworkURL,
											  width: 120,
											  aspectRatio: 1))
				}
			}
		}
		.padding(.horizontal)
	}
}

#Preview {
	NewsView()
		.environmentObject(NewsViewModel())
		.environment(\.managedObjectContext, NewsViewModel().mainContext)
}
