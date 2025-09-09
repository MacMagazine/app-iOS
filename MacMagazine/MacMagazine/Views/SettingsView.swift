import CommonLibrary
import News
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

struct SettingsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    let items: [Menu] = [
        Menu(view: AnyView(Text("Remover Propagandas".uppercased())),
             tip: SideMenuTips.subscriptions,
             children: [Menu(view: AnyView(SubscriptionView()))]),
        Menu(view: AnyView(Text("Posts".uppercased())),
             tip: SideMenuTips.posts,
             children: [Menu(view: AnyView(PostsVisibilityView()))]),
        Menu(view: AnyView(Text("Opções".uppercased())),
             tip: SideMenuTips.settings,
             children: [
                Menu(view: AnyView(PushOptionsView())),
                Menu(view: AnyView(AppearanceView()))
             ])
    ]
    
    var body: some View {
        ZStack {
            (theme.main.background.color ?? Color(uiColor: .systemGray6))
                .edgesIgnoringSafeArea(.all)

            VStack {
                LogoMenuView()
                    .padding(.bottom)

                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(items, id: \.id) { row in
                            VStack {
                                row.tip?.tipView(with: theme)

                                if let children = row.children {
                                    row.view
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    ForEach(children, id: \.id) { childrenRow in
                                        childrenRow.view
                                            .frame(maxWidth: 540)
                                    }

                                } else {
                                    row.view
                                }
                            }
                        }
                        Spacer()

                        SideMenuTips.about.tipView(with: theme)
                        AboutView()
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
            }
            .padding()
        }
        .navigationBarHidden(true)
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

extension SettingsView {
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
    SettingsView()
        .environmentObject(SettingsViewModel())
        .environment(\.theme, ThemeColor())
}

struct FavouriteView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: NewsViewModel
    
    var body: some View {
        Button(action: {
            viewModel.options = .favourites
        }, label: {
            HStack {
                Text("Favoritos")
                Spacer()
            }
            .tint(theme.main.tint.color)
        })
    }
}
