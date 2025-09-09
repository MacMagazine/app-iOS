import CommonLibrary
import News
import Settings
import SwiftUI

struct ScrollViewWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct Menu: Identifiable {
    let id = UUID()
    let view: AnyView
    let children: [Menu]?

    init(view: AnyView,
         children: [Menu]? = nil) {
        self.view = view
        self.children = children
    }
}

struct SettingsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @State private var scrollViewWidth: CGFloat = 0

    let items: [Menu] = [
        Menu(view: AnyView(Text("Remover Propagandas".uppercased())),
             children: [Menu(view: AnyView(SubscriptionView()))]),
        Menu(view: AnyView(Text("Posts".uppercased())),
             children: [Menu(view: AnyView(PostsVisibilityView()))]),
        Menu(view: AnyView(Text("Opções".uppercased())),
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
                    VStack {
                        ForEach(items, id: \.id) { row in
                            VStack {
                                if let children = row.children {
                                    row.view
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    ForEach(children, id: \.id) { childrenRow in
                                        childrenRow.view
                                    }

                                } else {
                                    row.view
                                }
                            }.padding(.horizontal, 2)
                        }
                        Spacer()
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
        HStack {
            Spacer()

            Image("menu")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 28)

            Image("MacMagazine")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
                .padding(.top, 10)

            Spacer()
        }
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
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
        .environment(\.theme, ThemeColor())
}
