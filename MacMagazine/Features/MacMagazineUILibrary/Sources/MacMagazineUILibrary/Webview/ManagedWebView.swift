import SwiftUI
@preconcurrency import WebKit

/// Style configuration for `ManagedWebView`.
public struct ManagedWebViewStyle {
    public var ignoredSafeAreaEdges: Edge.Set = []
    public var backForwardGesturesDisabled: Bool = false
    public var reloadsOnColorSchemeChange: Bool = false

    public init(
        ignoredSafeAreaEdges: Edge.Set = [],
        backForwardGesturesDisabled: Bool = false,
        reloadsOnColorSchemeChange: Bool = false
    ) {
        self.ignoredSafeAreaEdges = ignoredSafeAreaEdges
        self.backForwardGesturesDisabled = backForwardGesturesDisabled
        self.reloadsOnColorSchemeChange = reloadsOnColorSchemeChange
    }
}

/// A reusable view that manages the WebPage lifecycle, scenePhase crash
/// prevention, status overlay, and error handling.
///
/// Callers provide:
/// - A `pageProvider` closure that creates/returns the WebPage.
/// - A `loadAction` closure that iterates `page.load(...)` and returns on `.finished`.
/// - An optional `postLoadAction` for work after `.done` (e.g., navigation observation).
/// - A `style` controlling visual presentation.
public struct ManagedWebView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme

    @State private var viewStatus = WebViewStatus.idle
    @State private var isActive = true

    let style: ManagedWebViewStyle
    let pageProvider: @MainActor () async -> WebPage?
    var loadAction: (@MainActor (WebPage) async throws -> Void)?
    var postLoadAction: (@MainActor (WebPage) async -> Void)?
    @Binding var page: WebPage?
    var reloadTrigger: UUID = UUID()

    public init(
        style: ManagedWebViewStyle = .init(),
        pageProvider: @escaping @MainActor () async -> WebPage?,
        loadAction: (@MainActor (WebPage) async throws -> Void)? = nil,
        postLoadAction: (@MainActor (WebPage) async -> Void)? = nil,
        page: Binding<WebPage?>,
        reloadTrigger: UUID = UUID()
    ) {
        self.style = style
        self.pageProvider = pageProvider
        self.loadAction = loadAction
        self.postLoadAction = postLoadAction
        self._page = page
        self.reloadTrigger = reloadTrigger
    }

    public var body: some View {
        ZStack {
            webview
            WebViewStatusOverlay(status: viewStatus)
        }
        .task(id: reloadTrigger) {
            let activePage: WebPage?
            if let existing = page {
                activePage = existing
            } else {
                activePage = await pageProvider()
                self.page = activePage
            }
            guard let activePage else { return }
            await performLoad(on: activePage)
        }
        .onChange(of: scenePhase) { _, newPhase in
            isActive = newPhase == .active
        }
    }
}

// MARK: - Private

private extension ManagedWebView {
    @ViewBuilder
    var webview: some View {
        if let page, isActive {
            WebView(page)
                .webViewBackForwardNavigationGestures(
                    style.backForwardGesturesDisabled ? .disabled : .enabled
                )
                .ignoresSafeArea(.container, edges: style.ignoredSafeAreaEdges)
                .opacity(viewStatus == .done ? 1 : 0)
                .conditionalColorSchemeID(
                    enabled: style.reloadsOnColorSchemeChange,
                    colorScheme: colorScheme
                )
                .transition(.opacity)
        }
    }

    func performLoad(on page: WebPage) async {
        guard let loadAction else {
            // Page is preloaded (e.g. from cache) — skip loading
            viewStatus = .done
            return
        }

        viewStatus = .loading
        do {
            try await loadAction(page)
            viewStatus = .done
            if let postLoadAction {
                await postLoadAction(page)
            }
        } catch is CancellationError {
            // Task cancelled (view disappeared) — not an error
        } catch let error as WebPage.NavigationError {
            switch error {
            case .webContentProcessTerminated:
                // iOS terminated the web content process (e.g. app backgrounded)
                break
            default:
                if !Task.isCancelled {
                    viewStatus = .error(error.localizedDescription)
                }
            }
        } catch {
            if !Task.isCancelled {
                viewStatus = .error(error.localizedDescription)
            }
        }
    }
}

// MARK: - Conditional Color Scheme ID Modifier

private extension View {
    @ViewBuilder
    func conditionalColorSchemeID(enabled: Bool, colorScheme: ColorScheme) -> some View {
        if enabled {
            self.id(colorScheme)
        } else {
            self
        }
    }
}
