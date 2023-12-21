import Combine
import CommonLibrary
import CoreData
import CoreLibrary
import InAppPurchaseLibrary
import MessageUI
import OneSignalFramework
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

	@Published var notificationType: PushPreferences = .all

	@Published var subscriptionValid = false
	@Published var status: Status = .done
	@Published var products: [Product] = []

	@Published var postRead = false
	@Published var countOnBadge = false

	@Published public var cache: Cache?

	private var cancellables: Set<AnyCancellable> = []
	private var updates: Task<Void, Never>? = nil

	public let mainContext: NSManagedObjectContext
	let storage: Database
	let network: Network

	let delegate = MailDelegate()

	public init(network: Network = NetworkAPI()) {
		self.network = network
		self.storage = Database(db: "SettingsModel",
								resource: Bundle.module.url(forResource: "SettingsModel", withExtension: "momd"))
		self.mainContext = self.storage.mainContext

		observeState()

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
	private func observeState() {
		$isPatrao
			.receive(on: RunLoop.main)
			.removeDuplicates()
			.sink { [weak self] value in
				self?.storage.update(patrao: value)
			}
			.store(in: &cancellables)

		$postRead
			.receive(on: RunLoop.main)
			.removeDuplicates()
			.sink { [weak self] value in
				self?.storage.update(postRead: value)
				if !value {
					self?.countOnBadge = false
				}
			}
			.store(in: &cancellables)

		$countOnBadge
			.receive(on: RunLoop.main)
			.removeDuplicates()
			.sink { [weak self] value in
				self?.storage.update(countOnBadge: value)
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
		notificationType = await storage.notification
		postRead = await storage.postRead
		countOnBadge = await storage.countOnBadge

		if let expirationDate = await storage.expirationDate {
			subscriptionValid = expirationDate > Date()
		}

		Analytics.log(settings: [
			"icon": icon.rawValue as NSObject,
			"mode": mode.rawValue as NSObject,
			"patrao": isPatrao as NSObject,
			"notification": notificationType.rawValue as NSObject,
			"postRead": postRead as NSObject,
			"countOnBadge": countOnBadge as NSObject,
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

	@MainActor
	func change(_ type: PushPreferences) async {
		storage.update(notification: type.rawValue)
		OneSignal.User.addTag(key: "notification_preferences", value: type.rawValue)
	}
}

extension SettingsViewModel {
	@MainActor
	public func getPurchasableProducts() async throws {
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

extension SettingsViewModel {
	func composeMessage() {
		let destination = "contato@macmagazine.com.br"
		let subject = "Relato de problema no app MacMagazine \(Bundle.version ?? "versão desconhecida")."

		guard MFMailComposeViewController.canSendMail() else {
			if let url = URL(string: "mailto:\(destination)?subject=\(subject)"),
			   UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
			return
		}

		let composeVC = MFMailComposeViewController()
		composeVC.mailComposeDelegate = delegate
		composeVC.setSubject(subject)
		composeVC.setToRecipients([destination])

		(UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.last?.rootViewController?.present(composeVC,
																												  animated: true,
																												  completion: nil)
	}
}

// MARK: - Mail Methods -

class MailDelegate: NSObject, MFMailComposeViewControllerDelegate {
	public func mailComposeController(_ controller: MFMailComposeViewController,
									  didFinishWith result: MFMailComposeResult,
									  error: Error?) {
		controller.dismiss(animated: true)
	}
}
