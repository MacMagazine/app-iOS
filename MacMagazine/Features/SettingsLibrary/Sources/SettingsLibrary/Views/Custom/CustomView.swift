import MacMagazineLibrary
import SwiftUI

extension SettingsView {
    @ViewBuilder
    var customView: some View {
        let items = [
            Menu(view: AnyView(SubscriptionView(type: type))),
            Menu(view: AnyView(PostsVisibilityView(type: type))),
            Menu(view: AnyView(PushOptionsView(type: type))),
            Menu(view: AnyView(AppearanceView(type: type))),
            Menu(view: AnyView(IconsView(type: type))),
            Menu(view: AnyView(AboutView(type: type)))
        ]

        ZStack(alignment: .top) {
            // Background
            (theme.main.background.color ?? Color(uiColor: .systemGray6))
                .edgesIgnoringSafeArea(.all)

            // Floating header overlay
            logo

            // Scrollable content
            ScrollView {
                VStack{
                    // Top padding to account for header
                    Color.clear.frame(height: headerHeight)

                    ForEach(items, id: \.id) { row in
                        row.view
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
                            .onChange(of: geometry.frame(in: .named("scroll")).minY) { _, newValue in
                                // scrollOffset = max(0, -newValue)
                            }
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .scrollBounceBehavior(.basedOnSize)
        }
        .navigationBarHidden(true)
    }
}
