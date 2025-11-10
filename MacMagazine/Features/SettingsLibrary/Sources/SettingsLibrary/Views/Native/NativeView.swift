import SwiftUI

extension SettingsView {
    @ViewBuilder
    var nativeView: some View {
        let items: [Menu] = [
            Menu(view: AnyView(SubscriptionView(type: type))),
            Menu(view: AnyView(PostsVisibilityView(type: type))),
            Menu(view: AnyView(PushOptionsView(type: type))),
            Menu(view: AnyView(AppearanceView(type: type))),
            Menu(view: AnyView(IconsView(type: type))),
            Menu(view: AnyView(AboutView(type: type)))
        ]

        NavigationStack {
            VStack(spacing: 0) {
                logo
                
                List {
                    ForEach(items, id: \.id) { row in
                        row.view
                    }
                }
            }
        }
    }
}
