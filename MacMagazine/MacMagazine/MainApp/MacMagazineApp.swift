import AppTrackingTransparency
import CommonLibrary
import FirebaseAnalytics
import FirebaseCore
import Settings
import SwiftUI
import TipKit
import UIComponentsLibrary

class AppDelegate: NSObject, UIApplicationDelegate {
	static let shared = AppDelegate()

	var window: UIWindow?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

		FirebaseApp.configure()

//		ATTrackingManager.requestTrackingAuthorization { status in
//			Analytics.logEvent("ATTrackingManager", parameters: [:])
//		}

		return true
	}
}

@main
struct MacMagazineApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@Environment(\.scenePhase) var scenePhase

	@ObservedObject var viewModel = MainViewModel()

	var body: some Scene {
		WindowGroup {
			switch viewModel.currentView {
			case .splash:
				Text("")
					.task {
						if #available(iOS 17, *) {
#if DEBUG
//							try? Tips.resetDatastore()
#endif
							try? Tips.configure()
						}
						await viewModel.settingsViewModel.getSettings()
						viewModel.currentView = .settings
					}

			case .settings:
				SettingsView()
					.environmentObject(viewModel.settingsViewModel)
					.onChange(of: scenePhase) { phase in
						if phase == .active {
							Task {
								await viewModel.settingsViewModel.getSettings()
							}
						}
					}

			case .home:
				ContentView()
					.onChange(of: scenePhase) { phase in
						if phase == .active {
							Task {
								await viewModel.settingsViewModel.getSettings()
							}
						}
					}
			}
		}
		.environment(\.theme, viewModel.theme)
	}
}
