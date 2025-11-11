import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct PostsVisibilityView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @ObservedObject private var viewModel = PostsVisibilityViewModel()

    var body: some View {
        content
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
    @ViewBuilder
    var content: some View {
        NavigationLink {
            List {
                PushOptionsView()
                readAll
                identifyPosts
                countPosts
                cleanPosts
            }
        } label: {
            Text("Posts")
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
            .accessibilityLabel("Marcar todos os posts como já lidos")
        }
    }

    var identifyPosts: some View {
        Section {
            HStack {
                Text("Identificar posts já lidos")
                Spacer()
                Toggle("", isOn: $viewModel.postRead)
                    .labelsHidden()
                    .tint(theme.button.primary.color)
            }
        } footer: {
            Text("Marca visualmente os posts que você já leu")
        }
    }

    var countPosts: some View {
        Section {
            HStack {
                Text("Contar posts não lidos no ícone do app")
                Spacer()
                Toggle("", isOn: $viewModel.countOnBadge)
                    .labelsHidden()
                    .tint(theme.button.primary.color)
                    .disabled(!viewModel.postRead)
            }
        } footer: {
            Text("Mostra um badge com o número de posts não lidos")
        }
    }

    var cleanPosts: some View {
        Section {
            NavigationLink {
                cleanCacheView
            } label: {
                Text("Limpar cache do app")
            }
        }
        .navigationTitle("Posts")
        .navigationBarHidden(false)
    }

    var cleanCacheView: some View {
        List {
            Button(action: { viewModel.cache = .keepFavoritesAndStatus },
                   label: {
                Text("Manter favoritos e status de leitura")
                    .foregroundStyle(theme.main.tint.color ?? .blue)
            })
            Button(action: { viewModel.cache = .keepStatus },
                   label: {
                Text("Manter status de leitura")
                    .foregroundStyle(theme.main.tint.color ?? .blue)
            })
            Button(action: { viewModel.cache = .keepFavorites },
                   label: {
                Text("Manter favoritos")
                    .foregroundStyle(theme.main.tint.color ?? .blue)
            })
            Button(action: { viewModel.cache = .cleanImages },
                   label: {
                Text("Apagar somente as imagens")
                    .foregroundStyle(theme.main.tint.color ?? .blue)
            })
            Button(action: { viewModel.cache = .cleanAll },
                   label: {
                Text("Limpar tudo")
                    .foregroundStyle(theme.main.tint.color ?? .blue)
            })
        }
        .navigationTitle("Cache")
        .navigationBarHidden(false)
    }
}
