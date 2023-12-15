import Combine
import CommonLibrary
import CoreData
import CoreLibrary
import InAppPurchaseLibrary
import SwiftUI

public class SettingsViewModel: ObservableObject {
	enum Status: Equatable {
		case loading
		case done
		case error(reason: String)
		case purchasable(ids: [String])

		var reason: String? {
			switch self {
			case .error(let reason):
				return reason
			default:
				return nil
			}
		}

		var subscriptions: [String] {
			switch self {
			case .purchasable(let ids):
				return ids
			default:
				return []
			}
		}
	}

	@Published var icon: IconType = .normal
	@Published public var mode: ColorScheme = .light

	@Published var isPresentingPrivacy = false
	@Published var isPresentingTerms = false

	@Published var isPresentingLoginPatrao = false
	@Published var isPatrao = false

	@Published var subscriptionValid = false
	@Published var status: Status = .done
	@Published var products: [Product] = []

	private var cancellables: Set<AnyCancellable> = []

	public let mainContext: NSManagedObjectContext
	let storage: Database
	let network: Network

	public init(network: Network = NetworkAPI()) {
		self.network = network
		self.storage = Database(db: "SettingsModel",
								resource: Bundle.module.url(forResource: "SettingsModel", withExtension: "momd"))
		self.mainContext = self.storage.mainContext

		observeLoginStatus()
		observeInAppStatus()
	}
}

extension SettingsViewModel {
	private func observeLoginStatus() {
		$isPatrao
			.removeDuplicates()
			.sink { [weak self] status in
				self?.storage.update(patrao: status)
			}
			.store(in: &cancellables)
	}

	private func observeInAppStatus() {
		Subscriptions.shared.status = { [weak self] status in
			print(status)
			switch status {
			case .gotProducts(let products):
				self?.products = products
				self?.status = .done

			case .processing: break
			case .purchasedSuccess: break
			case .expired: break
			case .canPurchase: break
			case .disabled: break
			case .fail: break
			case .nothingToRestore: break
			}
		}
	}
}

extension SettingsViewModel {
	@MainActor
	public func getSettings() async {
		mode = await storage.mode
		isPatrao = await storage.patrao
		icon = await storage.appIcon

		Analytics.log(settings: [
			"icon": icon.rawValue as NSObject,
			"mode": mode.rawValue as NSObject,
			"patrao": isPatrao as NSObject,
		])
	}
}

extension SettingsViewModel {
	@MainActor
	func change(_ icon: IconType) async {
		guard UIApplication.shared.supportsAlternateIcons else {
			return
		}

		do {
			try await UIApplication.shared.setAlternateIconName(icon.appIcon)
			storage.update(appIcon: icon)
			self.icon = icon
		} catch {
		}
	}

	@MainActor
	func change(_ mode: ColorScheme) async {
		storage.update(mode: mode)
	}
}

extension SettingsViewModel {
	@MainActor
	func getPurchasableProducts() async throws {
		do {
			status = .loading
			let endpoint = Endpoint.config()
			MockURLProtocol(bundle: .module).mock(api: endpoint.restAPI)

			let data = try await network.get(url: endpoint.url, headers: nil)
			let object = try JSONDecoder().decode(PurchaseRequest.self, from: data)

			status = .purchasable(ids: object.subscriptions)
			Subscriptions.shared.get(products: object.subscriptions)

		} catch {
			status = .error(reason: error.localizedDescription)
			throw NetworkError.error(reason: error.localizedDescription)
		}
	}

	func manageSubscriptions() {
		guard let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") else {
			return
		}
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}

}
