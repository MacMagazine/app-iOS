import CommonLibrary
import SwiftUI
import UIComponentsLibrary

public struct PushOptionsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: SettingsViewModel

    public init() {}

    public var body: some View {
        VStack(spacing: 20) {
            Section(header:
                        Text("Notificações")
                .font(.headline)
                .foregroundColor(theme.text.terciary.color)
            ) {
                optionsView
            }
        }
    }
}

extension PushOptionsView {
    @ViewBuilder
    private var optionsView: some View {
        Picker("", selection: $viewModel.notificationType) {
            Text("Todos os posts").tag(PushPreferences.all)
                .accessibilityLabel(PushPreferences.all.accessibilityText(selected: viewModel.notificationType == PushPreferences.all))

            Text("Somente destaques").tag(PushPreferences.featured)
                .accessibilityLabel(PushPreferences.featured.accessibilityText(selected: viewModel.notificationType == PushPreferences.featured))
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.notificationType) { _, value in
            Task { await viewModel.change(value) }
        }
    }
}

#Preview {
    VStack {
        PushOptionsView()
        Spacer()
    }
    .padding()
    .environment(\.theme, ThemeColor())
    .environmentObject(SettingsViewModel())
}
