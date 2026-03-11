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

    var body: some View {
        NavigationLink {
            List {
                PushOptionsView()
                countPosts
                cleanPosts
            }
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
            .trackScreen(
                AnalyticsConstants.Screen.settingsPosts.name,
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

        .onChange(of: viewModel.countOnBadge) { _, value in
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.countPostsOnBadge(value).id,
                screen: AnalyticsConstants.Screen.settingsPosts.name
            ))

            #if os(iOS)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            #endif
            Task { await viewModel.change(countOnBadge: value) }
        }
    }
}

private extension PostsVisibilityView {
    var countPosts: some View {
        Section {
            Toggle("Contar posts não lidos no ícone do app", isOn: $viewModel.countOnBadge)
                .tint(theme.button.primary.color)

            Button(action: {
                viewModel.cache = .allRead
                analytics.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.allPostsRead.id,
                    screen: AnalyticsConstants.Screen.settingsPosts.name
                ))
            }, label: {
                Text("Marcar todos os posts como lidos")
                    .foregroundStyle(theme.main.tint.color ?? .blue)
            })
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
                analytics.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.cleanPostsOptions.id,
                    screen: AnalyticsConstants.Screen.settingsPosts.name
                ))
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
            UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
            UserDefaults.standard.removeObject(forKey: "hasSeenOnboardingFeatures")
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.cleanOnboarding.id,
                screen: AnalyticsConstants.Screen.settingsPosts.name
            ))
        },
               label: {
            Text("Rever Onboarding")
        })
        Button(action: {
            viewModel.flush(cache: .keepFavoritesAndStatus)
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.cleanPosts.id,
                screen: AnalyticsConstants.Screen.settingsPosts.name
            ))
        },
               label: {
            Text("Manter favoritos e status de leitura")
        })
        Button("Limpar tudo", role: .destructive) {
            viewModel.flush(cache: .cleanAll)
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.cleanAllPosts.id,
                screen: AnalyticsConstants.Screen.settingsPosts.name
            ))
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
