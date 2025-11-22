import MacMagazineLibrary
import SettingsLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary

struct NewsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: MainViewModel
    @State private var favorite = false
    let storage: Database

    var body: some View {
        NavigationStack {
            ZStack {
                (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
                content.padding(.top)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    menuView
                }
                ToolbarItem(placement: .principal) {
                    optionsView
                }
            }
        }
    }
}

private extension NewsView {
    var optionsView: some View {
        MenuView(menu: viewModel.settingsViewModel.news,
                 selected: $viewModel.news)
    }

    @ViewBuilder
    var content: some View {
        Text("News")
    }

    var menuView: some View {
        Button(action: {
            withAnimation {
                favorite.toggle()
            }
        }, label: {
            Image(systemName: favorite ? "star.fill" : "star")
        })
    }
}

#Preview {
    let storage = Database(models: [], inMemory: true)
    NewsView(storage: storage)
        .environment(\.theme, ThemeColor())
}
