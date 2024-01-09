import CommonLibrary
import SwiftUI
import UIComponentsLibrary

public enum NewsStyle {
	case home
	case carrousel
	case fullscreen
}

public struct NewsView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: NewsViewModel

	private var width: CGFloat
	private var filter: NewsViewModel.Category
	private var style: NewsStyle

	public init(filter: NewsViewModel.Category,
				fit width: CGFloat,
				style: NewsStyle) {
		self.filter = filter
		self.width = width
		self.style = style
	}

	public var body: some View {
		VStack {
			headerView
			styleView
		}
		.padding(.horizontal)

		.fullScreenCover(isPresented: Binding(get: { !viewModel.newsToShow.url.isEmpty },
											  set: { _, _ in })) {
			Webview(title: viewModel.newsToShow.title,
					url: viewModel.newsToShow.url,
					isPresenting: Binding(get: { !viewModel.newsToShow.url.isEmpty },
										  set: { _, _ in viewModel.newsToShow = NewsToShow(title: "", url: "") }))
		}
	}
}

extension NewsView {
	@ViewBuilder
	private var styleView: some View {
		switch style {
		case .home: 
			NewsFullView(filter: .news, limit: 6)
		case .carrousel:
			CarrouselView(filter: filter, fit: width)
		case .fullscreen:
			ScrollView {
				NewsFullView(filter: filter)
			}
		}
	}

	@ViewBuilder
	private var headerView: some View {
		if style == .fullscreen {
			HeaderFullView(title: filter.title, theme: theme) {
				withAnimation {
					viewModel.options = .home
				}
			}
			.padding(.top)

		} else if filter.showHeader {
			HeaderView(title: filter.header, theme: theme) {
				withAnimation {
					viewModel.options = .filter(category: filter)
				}
			}
		}
	}
}
