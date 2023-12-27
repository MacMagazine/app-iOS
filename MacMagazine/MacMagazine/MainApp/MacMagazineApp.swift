import AppTrackingTransparency
import CommonLibrary
import CoreLibrary
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

	@State var colorScheme: SwiftUI.ColorScheme? = DefaultStorage.colorScheme {
		didSet {
			DefaultStorage.update(colorScheme)
		}
	}

	var body: some Scene {
		WindowGroup {
			MainView()
				.environmentObject(viewModel)
				.environmentObject(viewModel.videosViewModel)
				.environmentObject(viewModel.settingsViewModel)
				.environmentObject(viewModel.newsViewModel)

				.task {
					if #available(iOS 17, *) {
#if DEBUG
//						try? Tips.resetDatastore()
#endif
						try? Tips.configure()
					}
					try? await viewModel.settingsViewModel.getPurchasableProducts()
					await viewModel.settingsViewModel.getSettings()
				}

				.onChange(of: scenePhase) { phase in
					if phase == .active {
						Task {
							await viewModel.settingsViewModel.getSettings()
						}
					}
				}

				.onReceive(viewModel.settingsViewModel.$mode) { value in
					colorScheme = value.colorScheme
				}
				.preferredColorScheme(colorScheme)
		}
		.environment(\.theme, viewModel.theme)
	}
}
