import CommonLibrary
import SwiftUI
import UIComponentsLibrary
import YouTubeLibrary

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
										  set: { _, _ in viewModel.newsToShow = NewsToShow(title: "", url: "", favorite: false) }),
					navigationDelegate: WebviewController(isPresenting: .constant(true),
														  removeAds: .constant(true)),
					userScripts: WebviewController().userScripts,
					scriptMessageHandlers: WebviewController().scriptMessageHandlers,
					userAgent: "/MacMagazine",
					extraActions: extraActions)
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

extension NewsView {
	@ViewBuilder
	private var extraActions: some View {
		Button(action: {
			let favorite = UIActivityExtensions(title: "Favorito",
												image: UIImage(systemName: viewModel.newsToShow.favorite ? "star.fill" : "star")) { _ in
//				Favorite().updatePostStatus(using: link) { [weak self] isFavorite in
//					self?.post?.favorito = isFavorite
//				}
			}

			let customCopy = UIActivityExtensions(title: "Copiar Link", image: UIImage(systemName: "link")) { items in
				for item in items {
					guard let url = URL(string: "\(item)") else {
						continue
					}
					UIPasteboard.general.url = url
				}
			}

			let items: [Any] = [viewModel.newsToShow.title, viewModel.newsToShow.url]

			Share().present(at: self, using: items, activities: [favorite, customCopy])
		}, label: {
			Image(systemName: "square.and.arrow.up.on.square.fill")
				.imageScale(.large)
				.foregroundColor(.primary)
		})
		.padding(.trailing)
	}
}
