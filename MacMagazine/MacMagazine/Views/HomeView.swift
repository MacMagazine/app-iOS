import CommonLibrary
import News
import SwiftUI
import Videos

struct HomeView: View {
	@EnvironmentObject private var viewModel: MainViewModel
	@State private var availableWidth: CGFloat = .infinity

	var body: some View {
		GeometryReader { geo in
			ScrollView {
				NewsView()
					.environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)

				VideosView(availableWidth: availableWidth)
			}
			.onChange(of: geo.size.width) { value in
				availableWidth = value
			}
		}
	}
}

#Preview {
	HomeView()
		.environmentObject(MainViewModel())
		.environmentObject(VideosViewModel())
}
