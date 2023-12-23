import CommonLibrary
import CoreData
import CoreLibrary
import SwiftUI
import UIComponentsLibrary
import YouTubeLibrary

public struct VideosFullView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: VideosViewModel
	@State private var title: String = "DICAS"
	@State private var search: String?

	public init() {}

	public var body: some View {
		ZStack {
			(theme.main.background.color ?? .black)
			.edgesIgnoringSafeArea(.all)

			VStack {
				HStack {
					HeaderView(title: title, theme: theme)
					Spacer()
					Button(action: {
						withAnimation {
							viewModel.options = .home
						}
					}, label: {
						Image(systemName: "xmark.circle")
							.imageScale(.large)
							.foregroundColor(theme.text.primary.color ?? Color(UIColor.label))
					})
				}

				ErrorView(message: viewModel.status.reason, theme: theme)
					.padding(.top)
				VideosFullscreenView(api: viewModel.youtube,
									 favorite: viewModel.options == .favorite,
									 search: search,
									 theme: theme)
				Spacer()
			}
			.padding([.leading, .trailing, .top])
			.task {
				try? await viewModel.youtube.getVideos()

				switch viewModel.options {
				case .search(let text):
					search = text
					title = "DICAS COM \(text)"
				case .all:
					search = nil
					title = "TODAS AS DICAS"
				case .favorite:
					search = nil
					title = "DICAS FAVORITAS"
				default:
					search = nil
					title = "DICAS"
				}
			}
		}
		.environment(\.managedObjectContext, viewModel.context)
	}
}

struct VideosFullView_Previews: PreviewProvider {
	static var previews: some View {
		VideosFullView()
			.environmentObject(VideosViewModel())
			.environment(\.theme, ThemeColor())
	}
}
