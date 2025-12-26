import SwiftUI

public struct PermissionCard: View {
    let title: String
    let icon: String
    let description: String
    let status: PermissionCardStatus
    let onRequest: () async -> Void

    @State private var isProcessing = false

    public init(
        title: String,
        icon: String,
        description: String,
        status: PermissionCardStatus,
        onRequest: @escaping () async -> Void
    ) {
        self.title = title
        self.icon = icon
        self.description = description
        self.status = status
        self.onRequest = onRequest
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header com ícone e título
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.primary)
                    .frame(width: 32)
                    .accessibilityHidden(true)

                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Spacer()
            }

            // Descrição
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            // Botão de status
            statusView
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var statusView: some View {
        switch status {
            case .notDetermined:
                Button {
                    isProcessing = true
                    Task {
                        await onRequest()
                        isProcessing = false
                    }
                } label: {
                    HStack(spacing: 6) {
                        if isProcessing {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(.white)
                        } else {
                            Text("Permitir")
                                .font(.subheadline.weight(.semibold))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .disabled(isProcessing)
                .accessibilityLabel("Permitir \(title)")
                .accessibilityHint("Toque para autorizar esta permissão")

            case .granted:
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.subheadline)
                    Text("Autorizado")
                        .font(.subheadline.weight(.semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.green)
                .clipShape(Capsule())
                .accessibilityLabel("\(title) autorizado")

            case .denied:
                HStack(spacing: 6) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.subheadline)
                    Text("Negado")
                        .font(.subheadline.weight(.semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.gray)
                .clipShape(Capsule())
                .accessibilityLabel("\(title) negado")
                .accessibilityHint("Você pode alterar nas Configurações do dispositivo")
        }
    }
}

// MARK: - Permission Card Status

public enum PermissionCardStatus {
    case notDetermined
    case granted
    case denied
}

// MARK: - Preview

#Preview("Permission Card - All States") {
    VStack(spacing: 16) {
        PermissionCard(
            title: "Notificações",
            icon: "bell.badge.fill",
            description: "Receba alertas instantâneos sobre as últimas notícias e podcasts.",
            status: .notDetermined,
            onRequest: {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        )

        PermissionCard(
            title: "App Analytics",
            icon: "chart.bar.fill",
            description: "Ajude-nos a melhorar o app com dados anônimos de uso.",
            status: .granted,
            onRequest: {}
        )

        PermissionCard(
            title: "Localização",
            icon: "location.fill",
            description: "Para mostrar notícias relevantes da sua região.",
            status: .denied,
            onRequest: {}
        )
    }
    .padding()
    .background(Color.black)
}
