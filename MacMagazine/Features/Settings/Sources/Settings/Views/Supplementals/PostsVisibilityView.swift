import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public struct PostsVisibilityView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @ObservedObject private var viewModel = PostsVisibilityViewModel()

    public init() {}

    public var body: some View {
        VStack(spacing: 20) {
            // Mark all as read button
            Button(action: {
                viewModel.cache = .readAll
            }, label: {
                Text("Marcar todos os posts como lidos".uppercased())
                    .roundedFullSize(fill: theme.button.primary.color ?? .blue)
            })
            .accessibilityLabel("Marcar todos os posts como já lidos")

            // Read status settings card
            VStack(spacing: 16) {
                HStack {
                    HStack(alignment: .top) {
                        Image(systemName: "app.badge.checkmark")
                            .font(.system(size: 20))
                            .foregroundColor(theme.button.primary.color ?? .blue)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("IDENTIFICAR POSTS JÁ LIDOS")
                                .font(.headline)
                            Text("Marca visualmente os posts que você já leu")
                                .font(.subheadline)
                        }
                        .foregroundColor(theme.text.terciary.color)
                    }
                    Spacer()

                    Toggle("", isOn: $viewModel.postRead)
                        .labelsHidden()
                        .tint(theme.button.primary.color)
                }

                Divider()
                    .padding(.leading, 32)

                HStack {
                    HStack(alignment: .top) {
                        Image(systemName: "app.badge")
                            .font(.system(size: 20))
                            .foregroundColor(theme.button.primary.color ?? .blue)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("CONTAR POSTS NÃO LIDOS NO ÍCONE DO APP")
                                .font(.headline)
                            Text("Mostra um badge com o número de posts não lidos")
                                .font(.subheadline)
                        }
                        .foregroundColor(theme.text.terciary.color)
                    }
                    Spacer()

                    Toggle("", isOn: $viewModel.countOnBadge)
                        .labelsHidden()
                        .tint(theme.button.primary.color)
                        .disabled(!viewModel.postRead)
                }
            }

            // Cache management disclosure
            DisclosureGroup(content: {
                disclosureContent.padding()
            }, label: {
                HStack(spacing: 12) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 20))
                        .foregroundColor(theme.main.tint.color ?? .blue)
                    Text("Limpar cache do app")
                }
            })
            .tint(theme.main.tint.color)
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

extension PostsVisibilityView {
    private var disclosureContent: some View {
        VStack {
            Button(action: { viewModel.cache = .keepFavoritesAndStatus },
                   label: {
                Text("manter favoritos e status de leitura".uppercased())
                    .roundedFullSize(fill: theme.button.primary.color ?? .blue)
            })
            Button(action: { viewModel.cache = .keepStatus },
                   label: {
                Text("manter status de leitura".uppercased())
                    .roundedFullSize(fill: theme.button.primary.color ?? .blue)
            })
            Button(action: { viewModel.cache = .keepFavorites },
                   label: {
                Text("manter favoritos".uppercased())
                    .roundedFullSize(fill: theme.button.primary.color ?? .blue)
            })
            Button(action: { viewModel.cache = .cleanImages },
                   label: {
                Text("Apagar somente as imagens".uppercased())
                    .borderedFullSize(color: theme.button.primary.color ?? .blue,
                                      stroke: theme.button.primary.color ?? .blue)
            })
            Button(action: { viewModel.cache = .cleanAll },
                   label: {
                Text("Limpar tudo".uppercased())
                    .borderedFullSize(color: theme.button.destructive.color ?? .blue,
                                      stroke: theme.button.destructive.color ?? .blue)
            })
        }
    }
}
