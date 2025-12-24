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
        ZStack(alignment: .top) {
            (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
            content
        }
        .navigationTitle("Notícias")
        .toolbar(show: !shouldUseSidebar, menu: favoriteButton, options: categoriesButton)
        .sheet(isPresented: $category) {
            categories
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(1/3)])
        }
        .task(id: viewModel.news) {
            withAnimation(.easeInOut(duration: 0.4)) {
                newsCategory = viewModel.news.toNewsCategory
                category = false
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
                category = true
            }
        }, label: {
            Image(systemName: "rectangle.grid.2x2\(category ? ".fill" : "")")
        })
    }

    @ViewBuilder
    var categories: some View {
        if category {
            @Bindable var bindableViewModel = viewModel

            NavigationStack {
                ChipView(options: viewModel.settingsViewModel.news,
                         selected: $bindableViewModel.news)
                .padding(.vertical, 10)
                .background(theme.main.background.color ?? Color.secondary)
                .navigationTitle("Categorias")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarSpacer(.flexible, placement: .topBarLeading)
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .close) {
                            category = false
                        }
                    }
                }
            }
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
