//
//  Subscriptions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 05/03/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Combine
import Foundation
import InAppPurchase

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

class Subscriptions {

	static let shared = Subscriptions()

	static let MMASSINATURAANUAL = "MMASSINATURAANUAL"
	static let MMASSINATURAMENSAL = "MMASSINATURAMENSAL"
	let identifiers = [MMASSINATURAMENSAL, MMASSINATURAANUAL]

	var productCancellable: AnyCancellable?
	var purchaseCancellable: AnyCancellable?
	var receiptCancellable: AnyCancellable?

	var status: ((InAppPurchaseStatus) -> Void)?
	var isPurchasing: Bool = false

	// MARK: - Methods -

	func checkSubscriptions(_ onCompletion: ((Bool) -> Void)? = nil) {
		productCancellable?.cancel()
		purchaseCancellable?.cancel()
		receiptCancellable?.cancel()

		var retry = 1

		receiptCancellable = InAppPurchaseManager.shared.$status
			.receive(on: RunLoop.main)
			.compactMap { $0 }
			.dropFirst()
			.removeDuplicates()
			.sink { [weak self] rsp in
				switch rsp {
				case .failure(_):
					onCompletion?(false)
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
						onCompletion?(false)
						self?.status?(.expired)

						retry -= 1
						if retry == 0 {
							InAppPurchaseManager.shared.refreshReceipt(subscription: Self.MMASSINATURAMENSAL)
						}

					default:
						onCompletion?(false)
						self?.status?(.canPurchase)
					}
				}
			}

		InAppPurchaseManager.shared.refreshReceipt(subscription: Self.MMASSINATURAANUAL)
	}

	func getProducts() {
		if InAppPurchaseManager.shared.canPurchase {
			if Settings().purchased {
				status?(.purchasedSuccess)
			} else {
				status?(.canPurchase)
				fetchProductInformation()
			}
		} else {
			status?(.disabled)
		}
	}

	func purchase(product: Product) {
		buy(product: product)
	}

	func restore() {
		buy(product: nil)
	}

	fileprivate func buy(product: Product?) {
		productCancellable?.cancel()
		purchaseCancellable?.cancel()
		receiptCancellable?.cancel()

		status?(.processing)

		purchaseCancellable = InAppPurchaseManager.shared.$status
			.receive(on: RunLoop.main)
			.compactMap { $0 }
			.removeDuplicates()
			.sink { [weak self] rsp in
				switch rsp {
				case .failure(_):
					self?.isPurchasing = false
					self?.status?(product == nil ? .nothingToRestore : .canPurchase)

				case .success(let response):
					var status: InAppPurchaseStatus {
						switch response {
						case .purchased:
							self?.isPurchasing = false
							return .purchasedSuccess
						case .purchasing,
								.restoring:
							return .processing
						case .restored:
							self?.checkSubscriptions()
							return .processing
						default:
							self?.isPurchasing = false
							return .canPurchase
						}
					}
					self?.status?(status)
				}
			}

		isPurchasing = true
		InAppPurchaseManager.shared.purchase(product: product)
	}
}

extension Subscriptions {
	fileprivate func fetchProductInformation() {
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

		InAppPurchaseManager.shared.getProducts(for: identifiers)
	}
}
