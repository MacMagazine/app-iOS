import CommonLibrary
import Settings
import SwiftUI
import UIComponentsLibrary
import UIComponentsLibrarySpecial
import YouTubeLibrary

public enum NewsStyle {
    case home
    case carrousel
    case fullscreen
}

public struct NewsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: NewsViewModel
    @EnvironmentObject private var settingsViewModel: SettingsViewModel

    @State private var showMore = true
    @State private var filter: NewsViewModel.Category?

    private var width: CGFloat

    public init(fit width: CGFloat) {
        self.width = width
    }

    public var body: some View {
        ZStack {
            (theme.main.background.color ?? Color(uiColor: .systemGray6))
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 10) {
                headerView
                styleView
            }
        }
        .onChange(of: viewModel.options) { _, filter in
            switch filter {
            case .filter(let category):
                self.filter = category
            default:
                self.filter = nil
            }
        }

        .navigationDestination(isPresented: Binding(get: { !viewModel.newsToShow.url.isEmpty },
                                                    set: { _, _ in
            try? viewModel.mainContext.save()
        })) {
            let webView = WebviewController(isPresenting: Binding(get: { !viewModel.newsToShow.url.isEmpty },
                                                                  set: { _, _ in }),
                                            removeAds: settingsViewModel.removeAds)

            Webview(title: viewModel.newsToShow.title,
                    url: viewModel.newsToShow.url,
                    isPresenting: Binding(get: { !viewModel.newsToShow.url.isEmpty },
                                          set: { _, _ in viewModel.newsToShow = NewsToShow(title: "", url: "", favorite: false, action: nil) }),
                    navigationDelegate: webView,
                    userScripts: webView.userScripts,
                    cookies: webView.cookies(using: settingsViewModel),
                    scriptMessageHandlers: webView.scriptMessageHandlers,
                    userAgent: "/MacMagazine",
                    extraActions: extraActions,
                    backButton: AnyView(Image(systemName: "arrow.left.circle.fill")
                        .imageScale(.large)
                        .tint(theme.tertiary.background.color)
                    ))
            .navigationBarHidden(true)
        }
    }
}

extension NewsView {
    @ViewBuilder
    private var styleView: some View {
        ScrollView {
            NewsFullView(filter: filter ?? .all)
        }
    }

    @ViewBuilder
    private var headerView: some View {
        CategoriesView()
            .padding(.horizontal)
    }
}

extension NewsView {
    @ViewBuilder
    private var extraActions: some View {
        Button(action: {
            let favorite = UIActivityExtensions(title: "Favorito",
                                                image: UIImage(systemName: viewModel.newsToShow.favorite ? "star.fill" : "star")) { _ in
                viewModel.newsToShow.favorite.toggle()
            }

            let customCopy = UIActivityExtensions(title: "Copiar Link", image: UIImage(systemName: "link")) { items in
                for item in items {
                    guard let url = URL(string: "\(item)") else {
                        continue
                    }
                    UIPasteboard.general.url = url
                }
            }

            Share().present(at: self,
                            using: [viewModel.newsToShow.title, viewModel.newsToShow.url],
                            activities: [favorite, customCopy])

        }, label: {
            Image(systemName: "square.and.arrow.up.on.square.fill")
                .imageScale(.large)
                .tint(theme.tertiary.background.color)
        })
    }
}

#Preview("Home") {
    let viewModel = NewsViewModel(inMemory: true)
    return NavigationStack {
        ScrollView {
            NewsView(fit: .infinity)
                .environment(\.managedObjectContext, viewModel.mainContext)
                .environmentObject(viewModel)
                .environmentObject(SettingsViewModel())
                .environment(\.theme, ThemeColor())
        }
    }
    .task {
        try? await viewModel.getNews()
    }
}
