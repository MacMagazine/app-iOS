import CommonLibrary
import SwiftUI

public struct Carrousel: View {
	@Environment(\.theme) private var theme: ThemeColor

	private var width: CGFloat
	private var filter: NewsViewModel.Category

	public init(filter: NewsViewModel.Category,
				fit width: CGFloat) {
		self.filter = filter
		self.width = width
	}

	public var body: some View {
		VStack {
			headerView
			CarrouselView(filter: filter, fit: width)
		}
		.padding(.horizontal)
	}
}

extension Carrousel {
	@ViewBuilder
	private var headerView: some View {
		if filter.showHeader {
			HeaderView(title: filter.title, theme: theme) {}
		}
	}
}
