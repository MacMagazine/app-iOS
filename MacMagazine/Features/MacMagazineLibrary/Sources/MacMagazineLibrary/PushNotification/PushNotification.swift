import Foundation
import LoggerLibrary
import Observation
import UserNotifications
import UtilityLibrary

public enum PushPermissionStatus: Equatable {
    case notDetermined
    case authorized
    case denied
}

@Observable
public class PushNotification: NSObject {
    public var newContentAvailable: String?
    private let logger: LoggerProtocol

    public override init() {
        self.logger = Logger(category: "MacMagazineV5")
    }
}

private extension PushNotification {
    static var oneSignalKey: String {
        let salt = "\(String(describing: "AppDelegate"))\(String(describing: NSObject.self))"
        let key: [UInt8] = [37, 68, 65, 114, 92, 85, 93, 84, 76, 70, 82, 120, 100, 98, 86, 91, 80, 83, 89, 121, 69, 66, 38, 72, 91, 92, 86, 88, 18, 7, 127, 106, 120, 91, 14, 83]
        return Obfuscator(with: salt).reveal(key: key)
    }
}

public extension PushNotification {
    @MainActor
    static var authorizationStatus: PushPermissionStatus {
        get async {
            switch await UNUserNotificationCenter.current().notificationSettings().authorizationStatus {
            case .notDetermined: .notDetermined
            case .denied: .denied
            case .authorized,
                    .provisional,
                    .ephemeral: .authorized
            @unknown default: .notDetermined
            }
        }
    }
}

public extension PushNotification {
    static func addDevice(with token: String) {
        guard let url = URL(string: "https://api.onesignal.com/apps/\(Self.oneSignalKey)/users") else { return }
        let headers = ["accept": "application/json",
                       "Content-Type": "application/json"]

        let payload = UserModel(
            properties: UserProperties(
                language: Locale.preferredLanguages.first,
                timezoneId: TimeZone.current.identifier,
                country: Locale.preferredLocales.first?.identifier
            ),
            identity: UserIdentity(
                externalId: token
            ),
            subscriptions: [UserSubscriptions(
                type: .ios,
                token: token,
                notificationTypes: 1,
                appVersion: Bundle.build
            )]
        )

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let postData = try? encoder.encode(payload) else { return }

        let logger = Logger(category: "MacMagazineV5")
        logger.debug(String(data: postData, encoding: .utf8) ?? "")

        Task {
            do {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headers
                request.httpBody = postData

                let (data, _) = try await URLSession.shared.data(for: request)
                logger.debug(String(data: data, encoding: .utf8) ?? "")
            } catch {
                logger.error(error.localizedDescription)
            }
        }
    }
}

#if canImport(OneSignalFramework)
import OneSignalFramework

public extension PushNotification {
    static func tag(with type: String) {
        OneSignal.User.addTag(key: "notification_preferences", value: type)
    }
}

#if canImport(UIKit)
import UIKit

@MainActor
public enum PushNotificationDefinition {
    public static var options: [UIApplication.LaunchOptionsKey: Any]?
}

public extension PushNotification {
    @MainActor
    func initialize(options: [UIApplication.LaunchOptionsKey: Any]?) {
        OneSignal.initialize(Self.oneSignalKey, withLaunchOptions: options)
        OneSignal.Notifications.addForegroundLifecycleListener(self)
        OneSignal.Notifications.addClickListener(self)
    }

    @MainActor
    func setup(options: [UIApplication.LaunchOptionsKey: Any]?) async -> Bool {
        initialize(options: options)

        return await withCheckedContinuation { continuation in
            OneSignal.Notifications.requestPermission({ accepted in
                continuation.resume(returning: accepted)
            }, fallbackToSettings: false)
        }
    }
}

extension PushNotification: OSNotificationLifecycleListener {
    public func onWillDisplay(event: OSNotificationWillDisplayEvent) {
        event.preventDefault()
        event.notification.display()
    }
}

extension PushNotification: OSNotificationClickListener {
    public func onClick(event: OSNotificationClickEvent) {
        let notification: OSNotification = event.notification
        guard let additionalData = notification.additionalData,
              let url = additionalData["url"] as? String, !url.isEmpty else {
            return
        }
        newContentAvailable = url
    }
}
#endif
#endif
