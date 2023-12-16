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
		case purchasable(products: [PurchaseRequest.Product])

		var subscriptions: [PurchaseRequest.Product] {
			switch self {
			case .purchasable(let products):
				return products
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
	private var updates: Task<Void, Never>? = nil

	public let mainContext: NSManagedObjectContext
	let storage: Database
	let network: Network

	public init(network: Network = NetworkAPI()) {
		self.network = network
		self.storage = Database(db: "SettingsModel",
								resource: Bundle.module.url(forResource: "SettingsModel", withExtension: "momd"))
		self.mainContext = self.storage.mainContext

		observeLoginStatus()

		updates = InAppPurchaseManager.observeTransactionUpdates { [weak self] result in
			if let expiration = result.first?.expiration {
				self?.storage.update(expiration: expiration)
				self?.subscriptionValid = expiration > Date()
			} else {
				self?.storage.update(expiration: Date())
				self?.subscriptionValid = false
			}
		}
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
}

extension SettingsViewModel {
	@MainActor
	public func getSettings() async {
		mode = await storage.mode
		isPatrao = await storage.patrao
		icon = await storage.appIcon

		if let expirationDate = await storage.expirationDate {
			subscriptionValid = expirationDate > Date()
		}

		Analytics.log(settings: [
			"icon": icon.rawValue as NSObject,
			"mode": mode.rawValue as NSObject,
			"patrao": isPatrao as NSObject,
			"subscriptionValid": subscriptionValid as NSObject
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

			status = .purchasable(products: object.subscriptions)

			let products = try await InAppPurchaseManager.shared.getProducts(for: object.subscriptions.map { $0.product })
			self.products = status.subscriptions.sorted(by: { $0.order < $1.order }).compactMap { value in
				products.first(where: { $0.identifier == value.product })
			}
			status = .done

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

	@MainActor
	func restore() {
		Task {
			try? await InAppPurchaseManager.shared.restore()
		}
	}

	@MainActor
	func purchase(_ product: Product) {
		Task {
			if let transaction = try await product.purchase().first(where: { product.identifier == $0.product }),
			   let expiration = transaction.expiration {
				storage.update(expiration: expiration)
				subscriptionValid = expiration > Date()
			} else {
				storage.update(expiration: Date())
				subscriptionValid = false
			}
		}
	}
}
