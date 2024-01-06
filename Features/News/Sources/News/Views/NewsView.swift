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
										 alignment: .top)],
					  spacing: 20) {
				ForEach(news.filter { !($0.allCategories?.contains(NewsViewModel.Category.highlights.rawValue) ?? true) }.prefix(6), id: \.self) { object in
					VStack {
						Text(object.title ?? "")
						Text(object.pubDateFormatted ?? "")
						Text(object.allCategories?.contains(NewsViewModel.Category.highlights.rawValue) ?? false ? "TRUE" : "")
					}
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
