import Combine
import Foundation
import InAppPurchaseLibrary

enum InAppPurchaseStatus {
	case canPurchase
	case processing
	case gotProducts([Product])
	case purchasedSuccess
	case expired
	case fail
	case disabled
	case nothingToRestore
}

public class Subscriptions {

	public static let shared = Subscriptions()

	var productCancellable: AnyCancellable?
	var purchaseCancellable: AnyCancellable?
	var receiptCancellable: AnyCancellable?

	var selectedProduct: Product?
	var status: ((InAppPurchaseStatus) -> Void)?

	// MARK: - Methods -

	public func checkSubscriptions(_ onCompletion: ((Bool) -> Void)? = nil) {
		productCancellable?.cancel()
		purchaseCancellable?.cancel()
		receiptCancellable?.cancel()

		receiptCancellable = InAppPurchaseManager.shared.$status
			.receive(on: RunLoop.main)
			.compactMap { $0 }
			.sink { [weak self] rsp in
				onCompletion?(false)

				switch rsp {
				case .failure:
					self?.status?(.canPurchase)

				case .success(let response):
					switch response {
					case .retrieving,
							.purchasing,
							.restoring,
							.validating:
						self?.status?(.processing)
					case .validated:
						onCompletion?(true)
						self?.status?(.purchasedSuccess)
					case .expired:
						self?.status?(.expired)
					default:
						self?.status?(.canPurchase)
					}
				}
			}

//		InAppPurchaseManager.shared.refreshReceipt(subscription: identifier)
	}

	func get(products: [String]) {
		if InAppPurchaseManager.shared.canPurchase {
//			status?(.purchasedSuccess)

			status?(.canPurchase)
			fetchInformation(products: products)
		} else {
			status?(.disabled)
		}
	}

	func purchase() {
		buy(restore: false)
	}

	func restore() {
		buy(restore: true)
	}

	fileprivate func buy(restore: Bool) {
		productCancellable?.cancel()
		purchaseCancellable?.cancel()
		receiptCancellable?.cancel()

		status?(.processing)

		purchaseCancellable = InAppPurchaseManager.shared.$status
			.receive(on: RunLoop.main)
			.compactMap { $0 }
			.sink { [weak self] rsp in
				switch rsp {
					// swiftlint:disable:next empty_enum_arguments
				case .failure(_):
					self?.status?(restore ? .nothingToRestore : .canPurchase)

				case .success(let response):
					var status: InAppPurchaseStatus {
						switch response {
						case .purchased:
							return .purchasedSuccess
						case .purchasing,
								.restoring:
							return .processing
						case .restored:
							self?.checkSubscriptions()
							return .processing
						default:
							return .canPurchase
						}
					}
					self?.status?(status)
				}
			}

		guard let product = selectedProduct else {
			return
		}
		InAppPurchaseManager.shared.purchase(product: restore ? nil : product)
	}
}

extension Subscriptions {
	fileprivate func fetchInformation(products: [String]) {
		productCancellable?.cancel()
		purchaseCancellable?.cancel()
		receiptCancellable?.cancel()

		status?(.processing)

		productCancellable = InAppPurchaseManager.shared.$products
			.receive(on: RunLoop.main)
			.compactMap { $0 }
			.sink { [weak self] rsp in
				switch rsp {
				case .failure(_):
					self?.status?(.fail)

				case .success(let response):
					if response.isEmpty {
						self?.status?(.fail)
					} else {
						self?.status?(.gotProducts(response))
					}
				}
			}

		InAppPurchaseManager.shared.getProducts(for: products)
	}
}
