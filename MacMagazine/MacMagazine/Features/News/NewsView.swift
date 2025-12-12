import FeedLibrary
import MacMagazineLibrary
import NetworkLibrary
import SettingsLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary

struct NewsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(MainViewModel.self) private var viewModel
    @Environment(SessionState.self) private var sessionState
    var feedViewModel: LocalHackViewModel

    @State private var favorite = false

    init(storage: Database) {
        self.feedViewModel = LocalHackViewModel(storage: storage)
    }

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
        .task {
            if feedViewModel.status == .idle && !sessionState.hasFetchedFeed {
                try? await feedViewModel.getFeed()
                sessionState.hasFetchedFeed = true
            }
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

// Hack provisório

@Observable
class LocalHackViewModel {
    var status: APIStatus = .idle

    private let feedService: FeedViewModel

    @MainActor
    init(storage: Database,
         mapper: [NetworkMockData]? = nil) {
        self.feedService = .init(
            network: NetworkFactory.make(mapper: mapper),
            storage: storage
        )
    }

    @MainActor
    func getFeed() async throws {
        do {
            status = .loading
            try await feedService.getFeed()
            status = .done
        } catch {
            status = .error(reason: error.localizedDescription)
        }
    }
}
