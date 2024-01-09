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
					NewsView(filter: .highlights, fit: availableWidth, style: .carrousel)
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.padding(.bottom)
						.id(MainViewModel.Page.highlights)

					NewsView(filter: .news, fit: availableWidth, style: .home)
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.padding(.bottom)
						.id(MainViewModel.Page.news)

					VideosView(availableWidth: availableWidth)
						.id(MainViewModel.Page.videos)

					NewsView(filter: .appletv, fit: availableWidth, style: .carrousel)
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.padding(.bottom)
						.id(MainViewModel.Page.appletv)

					NewsView(filter: .reviews, fit: availableWidth, style: .carrousel)
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.padding(.bottom)
						.id(MainViewModel.Page.reviews)

					NewsView(filter: .tutoriais, fit: availableWidth, style: .carrousel)
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.padding(.bottom)
						.id(MainViewModel.Page.tutoriais)

					NewsView(filter: .rumors, fit: availableWidth, style: .carrousel)
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.padding(.bottom)
						.id(MainViewModel.Page.rumors)
				}
				.onChange(of: geo.size.width) { value in
					availableWidth = value
				}
				.onChange(of: viewModel.selectedSection) { page in
					withAnimation { value.scrollTo(page, anchor: .top) }
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
