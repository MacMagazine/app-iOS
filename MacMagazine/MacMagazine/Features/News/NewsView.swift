import MacMagazineLibrary
import MacMagazineUILibrary
import NewsLibrary
import SettingsLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary

struct NewsView: View {
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(MainViewModel.self) private var viewModel

    @State private var favorite = false
    @State private var scrollPosition = ScrollPosition()
    @State private var newsCategory = NewsCategory.all
    @State private var isTransitioning = false

    var body: some View {
        ZStack(alignment: .top) {
            (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
            VStack {
                categories.padding(.horizontal)
                content.opacity(isTransitioning ? 0 : 1)
            }
        }
        .navigationTitle("Notícias")
        .toolbar(show: !shouldUseSidebar, menu: favoriteButton, options: EmptyView())
        .onChange(of: viewModel.news) { _, newValue in
            let newCategory = newValue.toNewsCategory
            guard newsCategory != newCategory else { return }

            withAnimation(.easeOut(duration: 0.15)) {
                isTransitioning = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                newsCategory = newCategory

                withAnimation(.easeIn(duration: 0.2)) {
                    isTransitioning = false
                }
            }
        }
        .onAppear {
            newsCategory = viewModel.news.toNewsCategory
        }
    }
}

private extension NewsView {
    var favoriteButton: some View {
        Button(action: {
            withAnimation {
                favorite.toggle()
            }
        }, label: {
            Image(systemName: "star\(favorite ? ".fill" : "")")
        })
    }

    @ViewBuilder
    var categories: some View {
        if !shouldUseSidebar {
            @Bindable var bindableViewModel = viewModel
            MenuView(
                menu: viewModel.settingsViewModel.news,
                selected: $bindableViewModel.news
            )
        }
    }

    var content: some View {
        NewsLibrary.NewsView(
            storage: viewModel.storage,
            favorite: $favorite,
            category: $newsCategory,
            scrollPosition: $scrollPosition
        )
    }
}
