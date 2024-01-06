import CommonLibrary
import News
import SwiftUI
import Videos

struct HomeView: View {
	@EnvironmentObject private var viewModel: MainViewModel
	@State private var availableWidth: CGFloat = .infinity

	var body: some View {
		ScrollViewReader { value in
			GeometryReader { geo in
				ScrollView(.vertical) {
					HighlightsView(availableWidth: availableWidth)
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.id(MainViewModel.Page.highlights)

					NewsView()
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.id(MainViewModel.Page.news)

					VideosView(availableWidth: availableWidth)
						.id(MainViewModel.Page.videos)
				}
				.onChange(of: geo.size.width) { value in
					availableWidth = value
				}
				.onChange(of: viewModel.selectedSection) { page in
					withAnimation { value.scrollTo(page) }
				}
			}
		}
	}
}

#Preview {
	HomeView()
		.environmentObject(MainViewModel())
		.environmentObject(VideosViewModel())
}
