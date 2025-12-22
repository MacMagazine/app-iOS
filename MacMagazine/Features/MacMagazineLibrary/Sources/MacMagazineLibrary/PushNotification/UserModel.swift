import Foundation

struct UserModel: Encodable {
    let properties: UserProperties
    let identity: UserIdentity
    let subscriptions: [UserSubscriptions]
}

struct UserProperties: Encodable {
    let language: String?
    let timezoneId: String?
    let country: String?
}

struct UserIdentity: Encodable {
    let externalId: String
}

struct UserSubscriptions: Encodable {
    enum UserSubscriptionsType: String, Encodable {
        case ios = "iOSPush"
    }

    let type: UserSubscriptionsType
    let token: String
    let notificationTypes: Int
    let appVersion: String?
}
