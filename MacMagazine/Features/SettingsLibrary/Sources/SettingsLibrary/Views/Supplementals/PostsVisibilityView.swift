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
        cleanPosts
        .task {
            viewModel.set(
                storage: settingsViewModel.storage,
                models: settingsViewModel.models
                )
        }
    }
}

private extension PostsVisibilityView {
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
