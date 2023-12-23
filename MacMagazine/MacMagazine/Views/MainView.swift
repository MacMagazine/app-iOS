import CommonLibrary
import Settings
import SwiftUI
import Videos
import YouTubeLibrary

struct MainView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: MainViewModel
	@EnvironmentObject private var videosViewModel: VideosViewModel

	@State var isPresentingMenu = false

	init() {}

	var body: some View {
		ZStack {
			theme.main.background.color
				.edgesIgnoringSafeArea([.top, .leading, .trailing])

			TabView(selection: $viewModel.selectedView) {
				MenuView(isShowing: $isPresentingMenu,
						 menu: { AnyView(SectionsView()) },
						 content: { HomeView() })
				.tag(MainViewModel.Page.home)

				VideosFullView()
					.tag(MainViewModel.Page.videos)
			}

			SideMenu(isShowing: $isPresentingMenu,
					 content: AnyView(SideMenuView(selectedView: $viewModel.selectedView,
												   isPresentingMenu: $isPresentingMenu)))
		}
	}
}

#Preview {
	MainView()
		.environmentObject(MainViewModel())
		.environmentObject(VideosViewModel())
		.environment(\.theme, ThemeColor())
}
