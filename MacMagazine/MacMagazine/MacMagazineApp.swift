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

	@ObservedObject var settingsViewModel = SettingsViewModel()

	var body: some Scene {
		WindowGroup {
			SettingsView(viewModel: settingsViewModel)
				.preferredColorScheme(settingsViewModel.mode.colorScheme)
				.task {
					if #available(iOS 17, *) {
						#if DEBUG
//						try? Tips.resetDatastore()
						#endif
						try? Tips.configure()
					}
				}
		}
		.environment(\.theme, ThemeColorImplementation())
	}
}
