import Settings
import SwiftUI

struct ContentView: View {
	@EnvironmentObject private var settings: SettingsViewModel

    var body: some View {
		VStack {
			Text("\(settings.mode.rawValue)")
			Button(action: {},
				   label: { Text("Settings") })
		}
    }
}

#Preview {
    ContentView()
}
