import MacMagazineLibrary
import SettingsLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary
import VideosLibrary

struct SocialView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: MainViewModel
    @State private var favorite = false
    @State private var scrollPosition = ScrollPosition()
    let storage: Database

    var body: some View {
        NavigationStack {
            ZStack {
                (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
                content
            }
            .contentMargins(.top, 20, for: .scrollContent)
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
        .onChange(of: viewModel.scrollToTopTrigger) { _, newValue in
            if newValue == .social {
                withAnimation {
                    scrollPosition.scrollTo(edge: .top)
                }
                viewModel.scrollToTopTrigger = nil
            }
        }
    }
}

private extension SocialView {
    var optionsView: some View {
        Picker("", selection: $viewModel.social) {
            ForEach(viewModel.settingsViewModel.social, id: \.self) { option in
                Text(option.rawValue).tag(option)
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    var content: some View {
        switch viewModel.social {
        case .videos: VideosView(storage: storage, favorite: $favorite, scrollPosition: $scrollPosition).transition(.opacity)
        case .podcast: Text("Podcast")
        case .instagram: Text("Instagram")
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
    let storage = Database(models: [], inMemory: true)
    SocialView(storage: storage)
        .environment(\.theme, ThemeColor())
}
