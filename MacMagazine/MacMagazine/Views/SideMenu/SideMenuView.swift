import CommonLibrary
import Settings
import SwiftUI
import TipKit

struct Menu: Identifiable {
	let id = UUID()
	let view: AnyView
	let tip: SideMenuTips?
	let children: [Menu]?

	init(view: AnyView,
		 tip: SideMenuTips? = nil,
		 children: [Menu]? = nil) {
		self.view = view
		self.tip = tip
		self.children = children
	}
}

struct SideMenuView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var settingsViewModel: SettingsViewModel

	@Binding var selectedView: MainViewModel.Page
	@Binding var isPresentingMenu: Bool

	let items: [Menu] = [
		Menu(view: AnyView(LogoMenuView())),
		Menu(view: AnyView(Text("Remover Propagandas")),
			 tip: SideMenuTips.subscriptions,
			 children: [Menu(view: AnyView(SubscriptionView()))]),
		Menu(view: AnyView(Text("Posts")),
			 tip: SideMenuTips.posts,
			 children: [Menu(view: AnyView(PostsVisibilityView()))]),
		Menu(view: AnyView(Text("Opções")),
			 tip: SideMenuTips.settings,
			 children: [
				Menu(view: AnyView(PushOptionsView())),
				Menu(view: AnyView(AppearanceView(theme: ThemeColor())))
			 ]),
		Menu(view: AnyView(AboutView()), tip: SideMenuTips.about)
	]

	var body: some View {
		GeometryReader { geo in
			HStack {
				List {
					ForEach(items, id: \.id) { row in
						Group {
							row.tip?.tipView(with: theme)

							if let children = row.children {
								DisclosureGroup(content: {
									ForEach(children, id: \.id) { childrenRow in
										childrenRow.view
									}
								},
												label: { row.view })
								.tint(theme.main.tint.color)

							} else {
								row.view
							}
						}
						.listRowSeparator(.hidden)
						.listRowBackground(Color.clear)
					}
				}
				.listStyle(.plain)
				.frame(width: geo.size.width > 430 ? 400 : geo.size.width * 0.9)
				.padding(.bottom)
				.background(theme.main.background.color ?? .primary)

				Spacer()
			}
		}
	}
}

struct LogoMenuView: View {
	@Environment(\.theme) private var theme: ThemeColor

	var body: some View {
		HStack(spacing: 10) {
			Spacer()
			Image("menu")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(height: 36)

			Image("MacMagazine")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(height: 24)
				.padding(.top, 10)

			Spacer()
		}
		.padding(.vertical, 10)
	}
}

extension SideMenuView {
	@ViewBuilder
	func row(isSelected: Bool,
			 title: String,
			 hideDivider: Bool = false,
			 action: @escaping () -> Void) -> some View {
		Button { action() } label: {
			HStack {
				Text(title)
					.foregroundColor(isSelected ? .black : .gray)
				Spacer()
			}
		}
		.frame(height: 50)
	}
}

#Preview {
	SideMenuView(selectedView: .constant(MainViewModel.Page.home),
				 isPresentingMenu: .constant(false))
	.environmentObject(SettingsViewModel())
	.environment(\.theme, ThemeColor())
}
