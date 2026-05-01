import SwiftUI
@preconcurrency import WebKit

/// Style configuration for `ManagedWebView`.
public struct ManagedWebViewStyle {
    public var ignoredSafeAreaEdges: Edge.Set = []
    public var backForwardGesturesDisabled: Bool = false

    public init(
        ignoredSafeAreaEdges: Edge.Set = [],
        backForwardGesturesDisabled: Bool = false
    ) {
        self.ignoredSafeAreaEdges = ignoredSafeAreaEdges
        self.backForwardGesturesDisabled = backForwardGesturesDisabled
    }
}

/// A reusable view that manages the WebPage lifecycle, scenePhase crash
/// prevention, status overlay, and error handling.
///
/// Callers provide:
/// - A `pageProvider` closure that creates/returns the WebPage.
/// - A `loadAction` closure that iterates `page.load(...)` and returns on `.finished`.
/// - An optional `postLoadAction` for work after `.done` (e.g., navigation observation).
/// - An optional `onColorSchemeChange` callback for cookie updates on theme change.
/// - A `style` controlling visual presentation.
public struct ManagedWebView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar

    @State private var viewStatus = WebViewStatus.idle
    @State private var isActive = true

    let style: ManagedWebViewStyle
    let pageProvider: @MainActor () async -> WebPage?
    var loadAction: (@MainActor (WebPage) async throws -> Void)?
    var postLoadAction: (@MainActor (WebPage) async -> Void)?
    var onColorSchemeChange: (@MainActor (WebPage, ColorScheme) async -> Void)?
    @Binding var page: WebPage?
    var reloadTrigger: UUID

    public init(
        style: ManagedWebViewStyle = .init(),
        pageProvider: @escaping @MainActor () async -> WebPage?,
        loadAction: (@MainActor (WebPage) async throws -> Void)? = nil,
        postLoadAction: (@MainActor (WebPage) async -> Void)? = nil,
        onColorSchemeChange: (@MainActor (WebPage, ColorScheme) async -> Void)? = nil,
        page: Binding<WebPage?>,
        reloadTrigger: UUID = UUID()
    ) {
        self.style = style
        self.pageProvider = pageProvider
        self.loadAction = loadAction
        self.postLoadAction = postLoadAction
        self.onColorSchemeChange = onColorSchemeChange
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
                _ = await pageProvider()
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
        .onChange(of: colorScheme) { _, newScheme in
            guard let onColorSchemeChange, let page else { return }
            Task {
                viewStatus = .loading
                await onColorSchemeChange(page, newScheme)
                await performLoad(on: page)
            }
        }
    }
}

// MARK: - Private

private extension ManagedWebView {
    @ViewBuilder
    var webview: some View {
        if let page, isActive {
            Color.clear
                .allowsHitTesting(false)
                .safeAreaInset(edge: .trailing, spacing: shouldUseSidebar ? nil : 0) {
                    WebView(page)
                        .webViewBackForwardNavigationGestures(
                            style.backForwardGesturesDisabled ? .disabled : .enabled
                        )
                        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
                        .ignoresSafeArea(.container, edges: style.ignoredSafeAreaEdges)
                        .opacity(viewStatus == .done ? 1 : 0)
                        .transition(.opacity)
                }
        }
    }

    func performLoad(on page: WebPage) async {
        guard let loadAction else {
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
