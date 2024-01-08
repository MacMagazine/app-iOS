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
					Carrousel(filter: .highlights, fit: availableWidth)
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.padding(.bottom)
						.id(MainViewModel.Page.highlights)

					NewsFullView()
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.padding(.bottom)
						.id(MainViewModel.Page.news)

					VideosView(availableWidth: availableWidth)
						.id(MainViewModel.Page.videos)

					Carrousel(filter: .appletv, fit: availableWidth)
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.padding(.bottom)
						.id(MainViewModel.Page.appletv)

					Carrousel(filter: .reviews, fit: availableWidth)
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.padding(.bottom)
						.id(MainViewModel.Page.reviews)

					Carrousel(filter: .tutoriais, fit: availableWidth)
						.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
						.padding(.bottom)
						.id(MainViewModel.Page.tutoriais)

					Carrousel(filter: .rumors, fit: availableWidth)
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
