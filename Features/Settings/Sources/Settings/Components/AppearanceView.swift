import CommonLibrary
import SwiftUI

public struct AppearanceView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: SettingsViewModel

    public init() {}

    public var body: some View {
        VStack(spacing: 20) {
            Section(header:
                        Text("Aparência")
                .font(.headline)
                .foregroundColor(theme.text.terciary.color)
            ) {
                Picker("", selection: $viewModel.mode) {
                    Text("Clara").tag(ColorScheme.light)
                        .accessibilityLabel(ColorScheme.light.accessibilityText(selected: viewModel.mode == ColorScheme.light))

                    Text("Escura").tag(ColorScheme.dark)
                        .accessibilityLabel(ColorScheme.dark.accessibilityText(selected: viewModel.mode == ColorScheme.dark))

                    Text("Sistema").tag(ColorScheme.system)
                        .accessibilityLabel(ColorScheme.system.accessibilityText(selected: viewModel.mode == ColorScheme.system))
                }
                .pickerStyle(.segmented)
            }
        }
        .task {
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(theme.text.primary.color ?? .primary)], for: .normal)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(theme.text.secondary.color ?? .secondary)], for: .selected)
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(theme.main.tint.color ?? .blue)
        }
        .onChange(of: viewModel.mode) { _, value in
            Task { await viewModel.change(value) }
        }
    }
}

#Preview {
    VStack {
        AppearanceView()
        Spacer()
    }
    .padding()
    .environment(\.theme, ThemeColor())
    .environmentObject(SettingsViewModel())
}
