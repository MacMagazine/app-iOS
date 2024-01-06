import CommonLibrary
import CoreData
import SwiftUI
import UIComponentsLibrary

public struct HighlightsView: View {
	private struct NewsToShow {
		let title: String
		let url: String
	}

	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: NewsViewModel
	@FetchRequest var news: FetchedResults<News>

	@State private var newsToShow = NewsToShow(title: "", url: "")

	private var width: CGFloat

	public init(availableWidth: CGFloat) {
		let request: NSFetchRequest<News> = News.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(keyPath: \News.pubDate, ascending: false)]
		_news = FetchRequest(fetchRequest: request)

		self.width = min(360, availableWidth * 0.82)
	}

	public var body: some View {
		ScrollView(.horizontal) {
			HStack(spacing: 4) {
				ForEach(news.filter { $0.allCategories?.contains(NewsViewModel.Category.highlights.rawValue) ?? true }.prefix(5), id: \.self) { object in
					show(highlight: object)
						.frame(width: width)
						.clipped()
				}
			}
		}
		.padding(.horizontal)

		.fullScreenCover(isPresented: Binding(get: { !newsToShow.url.isEmpty },
											  set: { _, _ in })) {
			Webview(title: newsToShow.title,
					url: newsToShow.url,
					isPresenting: Binding(get: { !newsToShow.url.isEmpty },
										  set: { _, _ in newsToShow = NewsToShow(title: "", url: "") }))
		}
	}
}

extension HighlightsView {
	@ViewBuilder
	private func show(highlight object: News) -> some View {
		Button(action: { 
			newsToShow = NewsToShow(title: object.title ?? "", url: object.shortURL ?? "")
		}, label: {
			ZStack {
				if let imageUrl = URL(string: object.artworkURL ?? "") {
					CachedAsyncImage(image: imageUrl, contentMode: .fill)
						.frame(height: width * 9 / 16)
						.cornerRadius(12, corners: .allCorners)
				}
				Rectangle().fill(.black).opacity(0.45)
					.frame(height: width * 9 / 16)
					.cornerRadius(12, corners: .allCorners)

				VStack {
					Spacer()

					HStack {
						Text(object.title ?? "")
							.foregroundColor(.white)
							.bold()
							.lineLimit(4)
							.multilineTextAlignment(.leading)
						Spacer()
					}

					HStack {
						Text(object.creator ?? "")
						Text(object.pubDateFormatted ?? "")
						Spacer()
					}
					.foregroundColor(.white)
					.lineLimit(1)
					.font(.subheadline)
				}
				.shadow(color: .black, radius: 1)
				.padding(.horizontal, 8)
				.padding(.bottom, 8)
			}
		})
	}
}

#Preview {
	HighlightsView(availableWidth: 360)
		.environmentObject(NewsViewModel())
		.environment(\.managedObjectContext, NewsViewModel().mainContext)
}
