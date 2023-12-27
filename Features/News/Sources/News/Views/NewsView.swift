import CommonLibrary
import CoreData
import SwiftUI

public struct NewsView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: NewsViewModel
	@FetchRequest var news: FetchedResults<News>

	public init() {
		let request: NSFetchRequest<News> = News.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(keyPath: \News.pubDate, ascending: false)]
		request.fetchLimit = 6

		_news = FetchRequest(fetchRequest: request)
	}

	public var body: some View {
		LazyVGrid(columns: [GridItem(.adaptive(minimum: 280),
									 alignment: .top)],
				  spacing: 20) {
			ForEach(0..<min(6, news.count), id: \.self) { index in
				VStack {
					Text(news[index].title ?? "")
					Text(news[index].pubDateFormatted ?? "")
					ForEach(news[index].categories ?? [], id: \.self) { categoria in
						Text(categoria)
					}
				}
			}
		}
				  .task {
					  try? await viewModel.getNews()
				  }
	}
}

#Preview {
	NewsView()
		.environmentObject(NewsViewModel())
}
