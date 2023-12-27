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
		request.fetchLimit = 6
		request.predicate = NSPredicate(format: "NONE categories IN %@", [NewsViewModel.Category.highlights.rawValue])

		_news = FetchRequest(fetchRequest: request)
	}

	public var body: some View {
		VStack {
			HStack {
				Text("Notícias")
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
				ForEach(0..<min(6, news.count), id: \.self) { index in
					VStack {
						Text(news[index].title ?? "")
						Text(news[index].pubDateFormatted ?? "")
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
