import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct PostsVisibilityView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(SettingsViewModel.self) private var settingsViewModel
    @State private var viewModel = PostsVisibilityViewModel()
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
            .trackScreen(
                "Ajustes > Posts",
                previous: nil,
                analytics: analytics
            )

        } label: {
            Label("Posts", systemImage: "text.page")
        }

        .task {
            viewModel.set(
                storage: settingsViewModel.storage,
                models: settingsViewModel.models
                )
            viewModel.get()
        }

        .onChange(of: viewModel.postRead) { _, value in
            analytics.track(.buttonTap(buttonId: "identify_posts_read \(value)", screen: "Ajustes > Posts"))

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
            analytics.track(.buttonTap(buttonId: "count_posts_on_badge \(value)", screen: "Ajustes > Posts"))

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
                analytics.track(.buttonTap(buttonId: "all_posts_read", screen: "Ajustes > Posts"))
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
            Button(action: {
                isPresenting.toggle()
                analytics.track(.buttonTap(buttonId: "clean_posts_options", screen: "Ajustes > Posts"))
            },
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
    }

    @ViewBuilder
    var cleanCacheView: some View {
        Button(action: {
            viewModel.flush(cache: .keepFavoritesAndStatus)
            analytics.track(.buttonTap(buttonId: "clean_posts", screen: "Ajustes > Posts"))
        },
               label: {
            Text("Manter favoritos e status de leitura")
        })
        Button("Limpar tudo", role: .destructive) {
            viewModel.flush(cache: .cleanAll)
            analytics.track(.buttonTap(buttonId: "clean_all_posts", screen: "Ajustes > Posts"))
        }
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
    .environment(SettingsViewModel(storage: storage, models: []))
}
#endif
