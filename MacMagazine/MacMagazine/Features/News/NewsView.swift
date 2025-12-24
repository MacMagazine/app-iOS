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
    @State private var category = false
    @State private var scrollPosition = ScrollPosition()
    @State private var newsCategory = NewsCategory.all

    var body: some View {
        ZStack {
            (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
            VStack {
                categoryView
                content
            }
        }
        .navigationTitle("Notícias")
        .toolbar(show: !shouldUseSidebar, menu: favoriteButton, options: categoriesButton)
        .onChange(of: viewModel.news) { _, value in
            newsCategory = value.toNewsCategory
            withAnimation(.easeInOut(duration: 0.4)) {
                category.toggle()
            }
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

    var categoriesButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.4)) {
                category.toggle()
            }
        }, label: {
            Image(systemName: "rectangle.grid.2x2\(category ? ".fill" : "")")
        })
    }

    @ViewBuilder
    var categoryView: some View {
        if category {
            @Bindable var bindableViewModel = viewModel
            ChipView(options: viewModel.settingsViewModel.news,
                     selected: $bindableViewModel.news)
            .transition(.move(edge: .top).combined(with: .opacity))
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
