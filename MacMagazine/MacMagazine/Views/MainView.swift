import CommonLibrary
import Settings
import SwiftUI

struct MainView: View {
	@State var isPresentingMenu = false
	@State var selectedView = 0

	var body: some View {
		ZStack {
			TabView(selection: $selectedView) {
				MenuView(isShowing: $isPresentingMenu) {
					HomeView()
				}.tag(0)
			}

			SideMenu(isShowing: $isPresentingMenu,
					 content: AnyView(SideMenuView(selectedView: $selectedView,
												   isPresentingMenu: $isPresentingMenu)))
		}
	}
}

#Preview {
	MainView()
		.environmentObject(SettingsViewModel())
		.environment(\.theme, ThemeColor())
}
