import CommonLibrary
import SwiftUI

public struct AppearanceView: View {
	private let theme: ThemeColor
	@EnvironmentObject private var viewModel: SettingsViewModel

	public init(theme: ThemeColor) {
		self.theme = theme

		UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(theme.text.primary.color ?? .primary)], for: .normal)
		UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(theme.text.secondary.color ?? .secondary)], for: .selected)
		UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(theme.main.tint.color ?? .blue)
	}

	public var body: some View {
		Section(header: Text("Aparência")
			.font(.headline)
			.foregroundColor(theme.text.terciary.color)) {
				SettingsTips.appearance.tipView(with: theme)
					.listRowBackground(Color.clear)

				appearanceView
					.padding(.vertical, 4)
					.listRowBackground(Color.clear)

				iconsView
					.padding(.vertical, 4)
					.listRowBackground(Color.clear)
			}
			.listRowSeparator(.hidden)
			.buttonStyle(PlainButtonStyle())
}
}

extension AppearanceView {
	@ViewBuilder
	private var appearanceView: some View {
		Picker("", selection: $viewModel.mode) {
			Text("Clara").tag(ColorScheme.light)
				.accessibilityLabel(ColorScheme.light.accessibilityText(selected: viewModel.mode == ColorScheme.light))

			Text("Escura").tag(ColorScheme.dark)
				.accessibilityLabel(ColorScheme.dark.accessibilityText(selected: viewModel.mode == ColorScheme.dark))

			Text("Sistema").tag(ColorScheme.system)
				.accessibilityLabel(ColorScheme.system.accessibilityText(selected: viewModel.mode == ColorScheme.system))
		}
		.pickerStyle(.segmented)
		.onChange(of: viewModel.mode) { value in
			Task { await viewModel.change(value) }
		}
	}

	@ViewBuilder
	private var iconsView: some View {
		LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), alignment: .top)],
		spacing: 20) {
			ForEach(IconType.allCases, id: \.self) { type in
				Button(action: {
					SettingsTips.appearance.invalidate()
					Task { await viewModel.change(type) }
				}, label: {
					Image(type.rawValue, bundle: .module)
						.resizable()
						.aspectRatio(contentMode: .fit)
				})
				.frame(width: 70, height: 70)
				.cornerRadius(12)
				.overlay(RoundedRectangle(cornerRadius: 12,
										  style: .continuous)
					.stroke(theme.text.primary.color ?? .blue, lineWidth: viewModel.icon == type ? 3 : 0)
				)
				.disabled(viewModel.icon == type)
				.opacity(viewModel.icon == type ? 0.5 : 1)
				.accessibilityLabel(type.accessibilityText(selected: viewModel.icon == type))
			}
		}
	}
}

#Preview {
	List {
		AppearanceView(theme: ThemeColor())
			.environmentObject(SettingsViewModel())
	}
}
