import CommonLibrary
import CoreData
import CoreLibrary
import SwiftUI
import UIComponentsLibrary
import YouTubeLibrary

public struct VideosFullView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@ObservedObject private var viewModel: VideosViewModel
	@Binding var options: VideosViewModel.Options
	private var title: String
	private var search: String?

	public init(viewModel: VideosViewModel = VideosViewModel(),
				options: Binding<VideosViewModel.Options>) {
		self.viewModel = viewModel
		_options = options

		switch options.wrappedValue {
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
							options = .home
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
									 favorite: options == .favorite,
									 search: search,
									 theme: theme)
				Spacer()
			}
			.padding([.leading, .trailing, .top])
			.task {
				try? await viewModel.youtube.getVideos()
			}
		}
		.environment(\.managedObjectContext, viewModel.context)
	}
}

struct VideosFullView_Previews: PreviewProvider {
	static var previews: some View {
		VideosFullView(options: .constant(.all))
			.environmentObject(VideosViewModel())
			.environment(\.theme, ThemeColor())
	}
}
