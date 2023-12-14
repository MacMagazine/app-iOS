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

extension URLSession {
	func decode<T: Decodable>(_ type: T.Type = T.self,
							  from url: URL) async throws -> T {
		let (data, _) = try await data(from: url)
		let decoded = try JSONDecoder().decode(T.self, from: data)
		return decoded
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
	let subscriptions: [String]
}
