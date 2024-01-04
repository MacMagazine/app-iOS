import CommonLibrary
import CoreData
import SwiftUI
import UIComponentsLibrary

public struct HighlightsView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: NewsViewModel
	@FetchRequest var news: FetchedResults<News>

	public init() {
		let request: NSFetchRequest<News> = News.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(keyPath: \News.pubDate, ascending: false)]
		_news = FetchRequest(fetchRequest: request)
	}

	public var body: some View {
		ScrollView(.horizontal) {
			HStack {
				ForEach(news.filter { $0.allCategories?.contains(NewsViewModel.Category.highlights.rawValue) ?? true }.prefix(6), id: \.self) { object in
					VStack {
						Text(object.title ?? "")
						Text(object.pubDateFormatted ?? "")
					}
				}
			}
		}
		.padding(.horizontal)
	}
}

#Preview {
	HighlightsView()
		.environmentObject(NewsViewModel())
		.environment(\.managedObjectContext, NewsViewModel().mainContext)
}
