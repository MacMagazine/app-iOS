import SwiftUI

extension PostsVisibilityView {
    var nativeView: some View {
        NavigationLink {
            detailView
        } label: {
            Text("Posts")
        }
    }
}

extension PostsVisibilityView {
    var detailView: some View {
        List {
            Section {
                Button(action: {
                    viewModel.cache = .readAll
                }, label: {
                    Text("Marcar todos os posts como lidos")
                        .foregroundStyle(theme.main.tint.color ?? .blue)
                })
                .accessibilityLabel("Marcar todos os posts como já lidos")
            }

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

            Section {
                NavigationLink {
                    cleanCacheView
                } label: {
                    Text("Limpar cache do app")
                }
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
