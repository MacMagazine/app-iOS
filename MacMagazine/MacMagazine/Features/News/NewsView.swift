import MacMagazineLibrary
import SettingsLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary

struct NewsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(MainViewModel.self) private var viewModel

    @State private var favorite = false

    var body: some View {
        @Bindable var bindableViewModel = viewModel

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

private extension NewsView {
    @ViewBuilder
    var optionsView: some View {
        @Bindable var bindableViewModel = viewModel

        MenuView(menu: viewModel.settingsViewModel.news,
                 selected: $bindableViewModel.news)
    }

    @ViewBuilder
    var content: some View {
        ContentUnavailableView(
            "Página em construção",
            systemImage: "square.and.arrow.down.badge.xmark",
            description: Text("Conteúdo ainda em desenvolvimento e estará disponível em breve.")
        )
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
