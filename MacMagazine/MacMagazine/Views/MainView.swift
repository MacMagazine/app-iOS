import CommonLibrary
import Settings
import SwiftUI
import Videos
import YouTubeLibrary

struct MainView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var videosViewModel: VideosViewModel

	@State var isPresentingMenu = false
	@State var selectedView = 0

	var body: some View {
		ZStack {
			theme.main.background.color
				.edgesIgnoringSafeArea([.top, .leading, .trailing])

			TabView(selection: $selectedView) {
				MenuView(isShowing: $isPresentingMenu) {
					HomeView()
				}.tag(0)

				VideosFullscreenView(api: videosViewModel.youtube,
									 theme: theme).tag(1)
			}

			SideMenu(isShowing: $isPresentingMenu,
					 content: AnyView(SideMenuView(selectedView: $selectedView,
												   isPresentingMenu: $isPresentingMenu)))
		}
	}
}

#Preview {
	MainView()
		.environmentObject(VideosViewModel())
		.environment(\.theme, ThemeColor())
}
