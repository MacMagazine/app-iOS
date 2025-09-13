import CommonLibrary
import CoreLibrary
import SwiftUI
import UIComponentsLibrary
import Videos

struct SocialView: View {
    enum Options: String, CaseIterable {
        case videos = "Videos"
        case podcast = "Podcast"
        case instagram = "Instagram"
    }

    @Environment(\.theme) private var theme: ThemeColor
    @State private var selected: Options = .videos

    var body: some View {
		ZStack {
			(theme.main.background.color ?? Color(uiColor: .systemGray6))
			.edgesIgnoringSafeArea(.all)

			VStack {
                menuView
                selectionView
                Spacer()
			}
            .padding(.horizontal)
		}
    }
}

extension SocialView {
    @ViewBuilder
    private var menuView: some View {
        MenuView(menu: Options.allCases,
                 selected: $selected)
    }
}

extension SocialView {
    @ViewBuilder
    private var selectionView: some View {
        switch selected {
        case .videos: VideosView()
        case .podcast: Text("Podcast")
        case .instagram: Text("Instagram")
        }
    }
}

#Preview {
    SocialView()
        .environment(\.theme, ThemeColor())
}
