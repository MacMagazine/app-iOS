import MacMagazineLibrary
import SwiftUI

struct IconsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @ObservedObject private var viewModel = IconsViewModel()

    var body: some View {
        Section {
            optionsView
        } header: {
            headerView
        }

        .task {
            viewModel.storage = settingsViewModel.storage
            viewModel.get()
        }
    }
}

private extension IconsView {
    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Ícone do app")
                    .font(.headline)
                Text("Personalize o ícone do aplicativo")
                    .font(.caption)
            }
        }
        .foregroundColor(theme.text.terciary.color)
    }

    @ViewBuilder
    var optionsView: some View {
        HStack(alignment: .top, spacing: 30) {
            Spacer()

            ForEach(IconType.allCases, id: \.self) { type in
                Button(action: {
                    Task { await viewModel.change(type) }
                }, label: {
                    VStack(spacing: 8) {
                        Image(type.rawValue, bundle: .module)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(theme.button.primary.color ?? .blue, lineWidth: viewModel.icon == type ? 2 : 0)
                            )
                            .shadow(color: viewModel.icon == type ? (theme.button.primary.color?.opacity(0.3) ?? .blue.opacity(0.3)) : .clear, radius: 8, x: 0, y: 4)

                        if viewModel.icon == type {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(theme.button.primary.color ?? .blue)
                        }
                    }
                })
                .disabled(viewModel.icon == type)
                .opacity(viewModel.icon == type ? 1 : 0.7)
                .scaleEffect(viewModel.icon == type ? 1.05 : 1)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.icon)
                .accessibilityLabel(type.accessibilityText(selected: viewModel.icon == type))
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}
