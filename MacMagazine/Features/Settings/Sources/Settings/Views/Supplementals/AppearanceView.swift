import MacMagazineLibrary
import SwiftUI

public struct AppearanceView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @ObservedObject private var viewModel = AppearanceViewModel()

    public init() {}

    public var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: "paintbrush.fill")
                    .font(.system(size: 20))
                    .foregroundColor(theme.button.primary.color ?? .blue)
                VStack(alignment: .leading, spacing: 4) {
                    Text("APARÊNCIA")
                        .font(.headline)
                    Text("Escolha o tema do aplicativo")
                        .font(.subheadline)
                }
            }
            .foregroundColor(theme.text.terciary.color)
            .padding(.bottom, 10)

            Picker("", selection: $viewModel.mode) {
                Text("Clara").tag(ColorScheme.light)
                    .accessibilityLabel(ColorScheme.light.accessibilityText(selected: viewModel.mode == ColorScheme.light))

                Text("Escura").tag(ColorScheme.dark)
                    .accessibilityLabel(ColorScheme.dark.accessibilityText(selected: viewModel.mode == ColorScheme.dark))

                Text("Sistema").tag(ColorScheme.system)
                    .accessibilityLabel(ColorScheme.system.accessibilityText(selected: viewModel.mode == ColorScheme.system))
            }
            .pickerStyle(.segmented)
            .padding(.vertical, 8)
        }

        .task {
            viewModel.storage = settingsViewModel.storage
            viewModel.get()
        }

        .onChange(of: viewModel.mode) { _, value in
            Task { await viewModel.change(value) }
        }
    }
}
