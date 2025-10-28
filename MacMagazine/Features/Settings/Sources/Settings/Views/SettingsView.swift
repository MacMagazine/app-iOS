import MacMagazineLibrary
// import News
import SwiftUI

public struct SettingsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @State private var scrollOffset: CGFloat = 0
    @State private var headerHeight: CGFloat = 80

    let oldItems: [Menu] = [
        Menu(view: AnyView(Text("Remover Propagandas".uppercased())),
             children: [Menu(view: AnyView(SubscriptionView()))]),
        Menu(view: AnyView(Text("Posts".uppercased())),
             children: [Menu(view: AnyView(PostsVisibilityView()))]),
        Menu(view: AnyView(Text("Opções".uppercased())),
             children: [
                Menu(view: AnyView(PushOptionsView())),
                Menu(view: AnyView(AppearanceView())),
                Menu(view: AnyView(IconsView()))
             ])
    ]

    let items: [Menu] = [
        Menu(view: AnyView(SubscriptionView())),
        Menu(view: AnyView(PostsVisibilityView())),
        Menu(view: AnyView(PushOptionsView())),
        Menu(view: AnyView(AppearanceView())),
        Menu(view: AnyView(IconsView())),
        Menu(view: AnyView(AboutView()))
    ]

    public init() {}

    // Calculate header opacity and scale based on scroll offset
    private var headerOpacity: Double {
        let fadeDistance: CGFloat = 100
        let opacity = max(0, min(1, 1 - (scrollOffset / fadeDistance)))
        return opacity
    }

    private var headerScale: CGFloat {
        let scaleDistance: CGFloat = 100
        let scale = max(0.8, min(1, 1 - (scrollOffset / scaleDistance) * 0.2))
        return scale
    }

    public var body: some View {
        ZStack(alignment: .top) {
            // Background
            (theme.main.background.color ?? Color(uiColor: .systemGray6))
                .edgesIgnoringSafeArea(.all)

            // Scrollable content
            ScrollView {
                VStack {
                    // Top padding to account for header
                    Color.clear
                        .frame(height: headerHeight)

                    ForEach(items, id: \.id) { row in
                        Group {
                            if let children = row.children {
                                VStack(alignment: .leading, spacing: 16) {
                                    row.view
                                        .font(.system(.title3, design: .rounded, weight: .bold))
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    VStack(spacing: 16) {
                                        ForEach(children, id: \.id) { childrenRow in
                                            childrenRow.view
                                        }
                                    }
                                }
                            } else {
                                row.view
                            }
                        }
                        .frame(maxWidth: 540)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(theme.text.secondary.color?.opacity(0.5) ?? Color(uiColor: .secondarySystemGroupedBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder((theme.button.primary.color ?? .blue).opacity(0.2), lineWidth: 2)
                        )
                    }
                }
                .padding()
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onChange(of: geometry.frame(in: .named("scroll")).minY) { oldValue, newValue in
                                scrollOffset = max(0, -newValue)
                            }
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .scrollBounceBehavior(.basedOnSize)

            // Floating header overlay
            VStack {
                LogoMenuView()
                    .background(
                        (theme.main.background.color ?? Color(uiColor: .systemGray6))
                            .opacity(0.95)
                    )
                    .opacity(headerOpacity)
                    .scaleEffect(headerScale, anchor: .top)
                    .animation(.easeInOut(duration: 0.2), value: scrollOffset)

                Spacer()
            }
            .allowsHitTesting(false)
        }
        .navigationBarHidden(true)
    }
}

struct LogoMenuView: View {
    @Environment(\.theme) private var theme: ThemeColor

    var body: some View {
        HStack {
            Image("menu")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 28)

            Image("MacMagazine")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}
