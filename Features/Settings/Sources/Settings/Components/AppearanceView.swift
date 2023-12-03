import CommonLibrary
import SwiftUI
import TipKit

struct AppearanceView: View {
	@ObservedObject private var viewModel: SettingsViewModel
	private let theme: ThemeColor

	init(viewModel: SettingsViewModel,
		 theme: ThemeColor) {
		self.viewModel = viewModel
		self.theme = theme

		UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(theme.text.primary.color ?? .primary)], for: .normal)
		UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(theme.text.secondary.color ?? .secondary)], for: .selected)
		UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(theme.main.tint.color ?? .blue)
	}

	var body: some View {
		Section(header: Text("Aparência")
			.font(.headline)
			.foregroundColor(theme.text.primary.color)) {
				SettingsTips.appearance.tipView(with: theme)

				appearanceView
					.padding(.vertical, 4)
					.listRowBackground(theme.main.background.color)

				iconsView
					.padding(.vertical, 4)
					.listRowBackground(theme.main.background.color)
			}
			.buttonStyle(PlainButtonStyle())
    }
}

extension AppearanceView {
	@ViewBuilder
	private var appearanceView: some View {
		Picker("", selection: $viewModel.mode) {
			Text("Clara").tag(ColorScheme.light)
			Text("Escura").tag(ColorScheme.dark)
			Text("Sistema").tag(ColorScheme.system)
		}
		.pickerStyle(.segmented)
		.onChange(of: viewModel.mode) { value in
			Task { await viewModel.change(value) }
		}
	}

	@ViewBuilder
	private var iconsView: some View {
		HStack {
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
				.frame(maxWidth: .infinity)
			}
		}
	}
}

#Preview {
	List {
		AppearanceView(viewModel: SettingsViewModel(), theme: ThemeColorImplementation())
	}
}

@available(iOS 17, *)
struct AppearanceTip: Tip {
	@Parameter
	static var isActive: Bool = true

	var title: Text { Text("Seu app, seu jeito") }
	var message: Text? { Text("Escolha a aparência do seu app, incluido modo escuro e ícone do app.") }

	var rules: [Rule] = [
		#Rule(Self.$isActive) { $0 == true }
	]

	var actions: [Action] {
		SettingsTips.appearance.add { tip in
			(tip as? SettingsTips)?.show()
		}
	}
}
