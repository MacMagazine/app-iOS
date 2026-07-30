import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public struct SafeguardView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @State private var coordinator: SafeguardCoordinator

    public init(coordinator: SafeguardCoordinator) {
        _coordinator = State(initialValue: coordinator)
    }

    public var body: some View {
        Group {
            if coordinator.shouldPresentUI {
                narratedFlow
            } else {
                silentFlow
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background((theme.main.background.color ?? .clear).ignoresSafeArea())
        .foregroundStyle(theme.text.primary.color ?? .primary)
        .task {
            await coordinator.run()
        }
    }

    // MARK: - Flow States

    private var narratedFlow: some View {
        VStack(spacing: 28) {
            Spacer()

            animationSlot

            messageView

            Spacer()

            if case let .failed(message) = coordinator.phase {
                failureActions(message: message)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
    }

    /// A fresh install has nothing to narrate, but it still has to hold the screen: every feature
    /// view inside `MainView` fetches the moment it composes, and none of them may run before the
    /// snapshot step does.
    private var silentFlow: some View {
        ProgressView()
            .controlSize(.large)
            .tint(theme.main.tint.color ?? .accentColor)
            .accessibilityLabel("Preparando o aplicativo")
    }

    // MARK: - Animation Slot

    /// Reserved for the Lottie animation; a themed progress indicator stands in until then.
    private var animationSlot: some View {
        Group {
            if coordinator.phase.isFailed {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 56))
                    .foregroundStyle(theme.button.destructive.color ?? .red)
            } else {
                ProgressView()
                    .controlSize(.extraLarge)
                    .tint(theme.main.tint.color ?? .accentColor)
            }
        }
        .frame(minHeight: 120)
        .accessibilityHidden(true)
    }

    // MARK: - Message

    private var messageView: some View {
        VStack(spacing: 10) {
            Text(coordinator.phase.title)
                .font(.title2.weight(.bold))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            Text(coordinator.phase.message)
                .font(.body)
                .foregroundStyle(theme.text.secondary.color ?? .secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }

    // MARK: - Failure Actions

    private func failureActions(message: String) -> some View {
        VStack(spacing: 12) {
            actionButton(
                "Tentar novamente",
                hint: "Reaplica seus favoritos e leituras a partir da cópia guardada",
                isProminent: true
            ) {
                await coordinator.retry()
            }

            actionButton(
                "Começar de novo",
                hint: "Descarta a cópia incompleta e refaz todo o processo desde o início",
                isProminent: false
            ) {
                await coordinator.restart()
            }
        }
        .accessibilityValue(message)
    }

    private func actionButton(
        _ title: String,
        hint: String,
        isProminent: Bool,
        action: @escaping () async -> Void
    ) -> some View {
        let accent = theme.button.primary.color ?? .blue

        return Button {
            Task { await action() }
        } label: {
            Text(title)
                .textCase(.uppercase)
                .font(.body.weight(.bold))
                .frame(maxWidth: .infinity, minHeight: 44)
                .padding(.vertical, 8)
                .background(isProminent ? accent : .clear)
                .foregroundStyle(isProminent ? .white : accent)
                .clipShape(Capsule())
                .overlay {
                    if !isProminent {
                        Capsule().strokeBorder(accent, lineWidth: 1.5)
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint(hint)
    }
}

// MARK: - Phase Copy

private extension SafeguardPhase {
    var title: String {
        switch self {
        case .snapshotting: "Protegendo seus dados"
        case .waitingForICloud: "Sincronizando com o iCloud"
        case .fetching: "Buscando as novidades"
        case .restoring: "Devolvendo seus dados"
        case .done: "Tudo pronto"
        case .failed: "Não foi possível concluir"
        }
    }

    var message: String {
        switch self {
        case .snapshotting: "Guardando seus favoritos, leituras e o progresso dos episódios."
        case .waitingForICloud: "Esperando o que está nos seus outros dispositivos chegar."
        case .fetching: "Atualizando as notícias e os podcasts."
        case .restoring: "Devolvendo seus favoritos e leituras para o lugar."
        case .done: "Seus dados estão a salvo. Bom proveito!"
        case let .failed(message): message
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Safeguard") {
    SafeguardView(coordinator: SafeguardCoordinator(
        models: [],
        mainContext: nil,
        statusSource: PreviewStatusSource(),
        clock: SystemSafeguardClock(),
        defaults: UserDefaults(suiteName: "safeguard.preview") ?? .standard,
        version: "5.1.0 (100)",
        fetch: {},
        deduplicate: {}
    ))
    .environment(\.theme, ThemeColor())
}

@MainActor
private final class PreviewStatusSource: SafeguardStatusSource {
    let isSyncEnabled = false
    let currentEvent: SafeguardSyncEvent = .other

    func nextEvent(timeout: TimeInterval) async -> SafeguardSyncEvent? { nil }
}
#endif
