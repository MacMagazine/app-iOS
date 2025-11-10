import Foundation

struct Subscription: Codable {
    var isPatrao: Bool
    var expirationDate: Date

    var isValidSubscription: Bool {
        expirationDate > Date()
    }

    var removeAds: Bool {
        isPatrao || isValidSubscription
    }
}
