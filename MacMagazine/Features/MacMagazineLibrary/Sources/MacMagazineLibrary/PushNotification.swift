import Foundation
import Observation
import UtilityLibrary

@Observable
public class PushNotification: NSObject {
    public var newContentAvailable: String?
}

private extension PushNotification {
    static var oneSignalKey: String {
        let salt = "\(String(describing: "AppDelegate"))\(String(describing: NSObject.self))"
        let key: [UInt8] = [37, 68, 65, 114, 92, 85, 93, 84, 76, 70, 82, 120, 100, 98, 86, 91, 80, 83, 89, 121, 69, 66, 38, 72, 91, 92, 86, 88, 18, 7, 127, 106, 120, 91, 14, 83]
        return Obfuscator(with: salt).reveal(key: key)
    }
}

public extension PushNotification {
    static func addDevice(with token: String) {
        guard let url = URL(string: "https://onesignal.com/api/v1/players") else { return }
        let headers = ["accept": "application/json",
                       "Content-Type": "application/json"]

        let parameters: [String: Any] = ["app_id": Self.oneSignalKey,
                                         "device_type": 0,
                                         "identifier": token]

        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }

        Task {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData

            _ = try? await URLSession.shared.data(for: request)
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

public extension PushNotification {
    func setup(options: [UIApplication.LaunchOptionsKey: Any]?) {
        OneSignal.initialize(Self.oneSignalKey, withLaunchOptions: options)
        OneSignal.Notifications.addForegroundLifecycleListener(self)
        OneSignal.Notifications.addClickListener(self)
        OneSignal.Notifications.requestPermission({ _ in }, fallbackToSettings: false)
    }
}

extension PushNotification: OSNotificationLifecycleListener {
    public func onWillDisplay(event: OSNotificationWillDisplayEvent) {
        event.preventDefault()
        // Database().update {
            event.notification.display()
        // }
    }
}

extension PushNotification: OSNotificationClickListener {
    public func onClick(event: OSNotificationClickEvent) {
        let notification: OSNotification = event.notification
        guard let additionalData = notification.additionalData,
              let content = additionalData as? [String: String] else {
            return
        }
        // Database().update { [weak self] in
            newContentAvailable = content["url"]
        // }
    }

    public static func handleBackground(for userInfo: [AnyHashable: Any]) {
        // Database().update(onCompletion: nil)
    }
}
#endif
#endif
