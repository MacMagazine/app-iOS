import MacMagazineLibrary
import PodcastLibrary
import SettingsLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary
import VideosLibrary

struct SocialView: View {
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(MainViewModel.self) private var viewModel

    @State private var favorite = false
    @State private var scrollPosition = ScrollPosition()

    var body: some View {
        socialContent
        .onChange(of: viewModel.scrollToTopTrigger) { _, newValue in
            if newValue == .social {
                withAnimation {
                    scrollPosition.scrollTo(edge: .top)
                }
                viewModel.scrollToTopTrigger = nil
            }
        }
    }

    var socialContent: some View {
        ZStack {
            (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
            content
        }
        .contentMargins(.top, 20, for: .scrollContent)
        .navigation(shouldUseSidebar: shouldUseSidebar,
                    title: viewModel.social.rawValue)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if viewModel.social != .instagram {
                    menuView
                }
            }
            ToolbarItem(placement: .principal) {
                if !shouldUseSidebar {
                    optionsView
                }
            }
        }
    }
}

private extension SocialView {
    @ViewBuilder
    var optionsView: some View {
        @Bindable var bindableViewModel = viewModel

        Picker("", selection: $bindableViewModel.social) {
            ForEach(viewModel.settingsViewModel.social, id: \.self) { option in
                Text(option.rawValue).tag(option)
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    var content: some View {
        switch viewModel.social {
        case .videos:
            VideosView(
                storage: viewModel.storage,
                favorite: $favorite,
                scrollPosition: $scrollPosition
            ).transition(.opacity)
        case .podcast:
            PodcastView(
                storage: viewModel.storage,
                favorite: $favorite,
                scrollPosition: $scrollPosition
            ).transition(.opacity)
        case .instagram:
            InstagramWebView(colorSchema: viewModel.settingsViewModel.colorSchema)
        }
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
    SocialView()
        .environment(\.theme, ThemeColor())
        .environment(MainViewModel(inMemory: true))
}
