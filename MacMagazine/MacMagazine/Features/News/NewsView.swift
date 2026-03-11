import AnalyticsLibrary
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
    @State private var showCategoryFilter = false
    @State private var scrollPosition = ScrollPosition()
    @State private var newsCategory = NewsCategory.all

    var body: some View {
        ZStack(alignment: .top) {
            (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
            content
                .contentMargins(.top, 20, for: .scrollContent)
        }
        .toolbar(type: toolbarType,
                 menu: favoriteButton,
                 options: categoriesButton)
        .onChange(of: viewModel.news) { _, newValue in
            let newCategory = newValue.toNewsCategory
            guard newsCategory != newCategory else { return }
            newsCategory = newCategory
            viewModel.analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.categoryFilterChanged(newValue.rawValue).id,
                screen: AnalyticsConstants.Screen.news.name
            ))
        }
        .trackScreen(
            AnalyticsConstants.Screen.news.name,
            previous: nil,
            analytics: viewModel.analytics
        )
        .onAppear {
            newsCategory = viewModel.news.toNewsCategory
        }
    }
}

private extension NewsView {
    var categoriesButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.4)) {
                showCategoryFilter.toggle()
                scrollPosition.scrollTo(edge: .top)
            }
        }, label: {
            Image(systemName: "rectangle.grid.2x2\(showCategoryFilter ? ".fill" : "")")
        })
        .accessibilityLabel(showCategoryFilter ? "Ocultar filtro por categorias" : "Mostrar filtro por categorias")
    }

    var favoriteButton: some View {
        Button(action: {
            withAnimation {
                favorite.toggle()
            }
        }, label: {
            Image(systemName: "star\(favorite ? ".fill" : "")")
        })
        .accessibilityLabel(favorite ? "Mostrar tudo" : "Mostrar Favoritos")
    }

    @ViewBuilder
    var categories: some View {
        if !shouldUseSidebar, showCategoryFilter {
            @Bindable var bindableViewModel = viewModel
            MenuView(
                menu: viewModel.settingsViewModel.news,
                selected: $bindableViewModel.news
            ).padding(.horizontal)
        }
    }

    var content: some View {
        NewsLibrary.NewsView(
            storage: viewModel.storage,
            favorite: $favorite,
            category: $newsCategory,
            filters: categories,
            scrollPosition: $scrollPosition
        )
    }
}

private extension NewsView {
    var toolbarType: ToolbarType {
        shouldUseSidebar ? .compact : .normal
    }
}
