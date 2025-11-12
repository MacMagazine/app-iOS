import MacMagazineLibrary
import SwiftUI

public struct SettingsView: View {
    @Environment(\.theme) var theme: ThemeColor

    let items: [Menu] = [
        Menu(view: AnyView(SubscriptionView())),
        Menu(view: AnyView(PostsVisibilityView())),
        Menu(view: AnyView(AppearanceView())),
        Menu(view: AnyView(IconsView())),
        Menu(view: AnyView(AboutView()))
    ]

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                ForEach(items, id: \.id) { row in
                    row.view
                }
            }
            .navigationTitle("MacMagazine")
//            .toolbar {
//                ToolbarItem(placement: .automatic) {
//                    logo
//                }
//            }
        }
    }
}

private extension SettingsView {
    var logo: some View {
        HStack {
            Image("Logo", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 28)

            Image("MacMagazine", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
        .padding(.top)
    }
}

#if DEBUG
import StorageLibrary

#Preview {
    let storage = Database(models: [SettingsDB.self], inMemory: true)

    SettingsView()
    .environment(\.theme, ThemeColor())
    .environmentObject(SettingsViewModel(storage: storage))
}
#endif

