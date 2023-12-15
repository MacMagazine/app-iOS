import SwiftUI

private struct SettingsKey: EnvironmentKey {
	static let defaultValue = SettingsViewModel()
}

extension EnvironmentValues {
	public var settings: SettingsViewModel {
		get { self[SettingsKey.self] }
		set { self[SettingsKey.self] = newValue }
	}
}

extension View {
	public func settings(_ value: SettingsViewModel) -> some View {
		environment(\.settings, value)
	}
}
