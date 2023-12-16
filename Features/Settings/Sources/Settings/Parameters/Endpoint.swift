import CoreLibrary
import Foundation

enum FirebaseDefinitions {
	static let host = "macmagazine-2c704.web.app"
	static let path = "/"
	static let configFile = "subscriptions.json"
}

extension Endpoint {
	static func config(customHost: CustomHost? = nil) -> Self {
		return Endpoint(customHost: customHost ?? CustomHost(host: FirebaseDefinitions.host,
															 path: FirebaseDefinitions.path),
						api: customHost?.api ?? FirebaseDefinitions.configFile,
						queryItems: customHost?.queryItems)
	}
}

enum NetworkError: Error {
	case unknown
	case error(reason: String)

	var reason: String? {
		switch self {
		case .error(let reason):
			return reason
		default:
			return nil
		}
	}
}

struct PurchaseRequest: Decodable {
	struct Product: Decodable, Equatable {
		let order: Int
		let product: String
	}

	let subscriptions: [PurchaseRequest.Product]
}
