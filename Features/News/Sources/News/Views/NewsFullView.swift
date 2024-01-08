import CommonLibrary
import CoreData
import SwiftUI
import UIComponentsLibrary

public struct NewsFullView: View {
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
			HeaderView(title: "Últimas Notícias", theme: theme) {
//				withAnimation {
//					viewModel.options = .all
//				}
			}

			LazyVGrid(columns: [GridItem(.adaptive(minimum: 280),
										 alignment: .top)]) {
				ForEach(news.filter { !($0.allCategories?.contains(NewsViewModel.Category.highlights.rawValue) ?? true) }.prefix(8), id: \.self) { object in
					CardView(object: CardData(style: .imageLast,
											  title: object.title,
											  creator: object.creator,
											  pubDate: object.pubDate(format: .mmDateTime),
											  artworkURL: object.artworkURL,
											  height: 120,
											  aspectRatio: 1))
				}
			}
		}
		.padding(.horizontal)
	}
}

#Preview {
	NewsFullView()
		.environmentObject(NewsViewModel())
		.environment(\.managedObjectContext, NewsViewModel().mainContext)
}
