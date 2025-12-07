import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct PostsVisibilityView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @StateObject private var viewModel = PostsVisibilityViewModel()
    @State private var isPresenting = false
    @State private var isPresentingMore = false

    var body: some View {
        NavigationLink {
            List {
                PushOptionsView()
                readAll
                countPosts
                cleanPosts
            }
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)

        } label: {
            Label("Posts", systemImage: "text.page")
        }

        .task {
            viewModel.storage = settingsViewModel.storage
            viewModel.get()
        }

        .onChange(of: viewModel.postRead) { _, value in
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            #endif
            Task { await
                viewModel.change(postRead: value)
                if !value {
                    viewModel.countOnBadge = false
                }
            }
        }
        .onChange(of: viewModel.countOnBadge) { _, value in
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            #endif
            Task { await viewModel.change(countOnBadge: value) }
        }
    }
}

private extension PostsVisibilityView {
    var readAll: some View {
        Section {
            Button(action: {
                viewModel.cache = .readAll
            }, label: {
                Text("Marcar todos os posts como lidos")
                    .foregroundStyle(theme.main.tint.color ?? .blue)
            })

            Toggle("Identificar posts já lidos", isOn: $viewModel.postRead)
                .tint(theme.button.primary.color)
        } header: {
            Text("Posts lidos")
                .font(.headline)
                .foregroundColor(theme.text.terciary.color)
        } footer: {
            Text("Marca visualmente os posts que você já leu")
                .accessibilityHidden(true)
        }
    }

    var countPosts: some View {
        Section {
            Toggle("Contar posts não lidos no ícone do app", isOn: $viewModel.countOnBadge)
                .tint(theme.button.primary.color)
                .disabled(!viewModel.postRead)
        } header: {
            Text("Badge")
                .font(.headline)
                .foregroundColor(theme.text.terciary.color)
        } footer: {
            Text("Mostra um badge com o número de posts não lidos")
                .accessibilityHidden(true)
        }
    }

    var cleanPosts: some View {
        Section {
            Button(action: { isPresenting.toggle() },
                   label: {
                Text("Limpar cache do app")
                    .foregroundStyle(theme.main.tint.color ?? .blue)
            })
        }
        .confirmationDialog("Selecione uma opção",
                            isPresented: $isPresenting,
                            titleVisibility: .visible) {
            cleanCacheView
        }
        .confirmationDialog("Selecione uma opção",
                            isPresented: $isPresentingMore,
                            titleVisibility: .visible) {
            moreOptionsCleanCacheView
        }
    }

    @ViewBuilder
    var cleanCacheView: some View {
        Button(action: { viewModel.cache = .keepFavoritesAndStatus },
               label: {
            Text("Manter favoritos e status de leitura")
        })
//        Button(action: { isPresentingMore.toggle() },
//               label: {
//            Text("Outras opções")
//        })
        Button("Limpar tudo", role: .destructive) { viewModel.cache = .cleanAll }
    }

    @ViewBuilder
    var moreOptionsCleanCacheView: some View {
        Button(action: { viewModel.cache = .keepStatus },
               label: {
            Text("Manter status de leitura")
        })
        Button(action: { viewModel.cache = .keepFavorites },
               label: {
            Text("Manter favoritos")
        })
        Button(action: { viewModel.cache = .cleanImages },
               label: {
            Text("Apagar somente as imagens")
        })
    }
}

#if DEBUG
import StorageLibrary

#Preview {
    let storage = Database(models: [SettingsDB.self], inMemory: true)

    NavigationStack {
        List {
            PostsVisibilityView()
        }
    }
    .environment(\.theme, ThemeColor())
    .environmentObject(SettingsViewModel(storage: storage))
}
#endif
