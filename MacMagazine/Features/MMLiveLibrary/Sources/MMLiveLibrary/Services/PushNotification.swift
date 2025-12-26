import Foundation
import StorageLibrary
import UserNotifications

protocol PushNotificationProtocol {
    @MainActor
    func setLocalNotification(for event: MMLive)
}

final class PushNotification: NSObject, PushNotificationProtocol {
    @MainActor
    func setLocalNotification(for event: MMLive) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        Task {
            let settings = await center.notificationSettings()
            if settings.authorizationStatus == .authorized {
                process(event: event)
            } else {
//                guard let granted = try? await center.requestAuthorization(options: [.alert, .sound, .badge]),
//                granted else { return }
//                process(event: event)
            }
        }
    }
}

private extension PushNotification {
    func process(event: MMLive) {
        startInterval(for: event)
        endInterval(for: event)
    }

    func startInterval(for event: MMLive) {
        let startInterval = event.inicio.timeIntervalSince(Date())
        if startInterval > 0 {
            let start = UNMutableNotificationContent()
            start.title = "MM Live irá começar"
            start.subtitle = "Acompanhe o evento ao vivo!"
            start.sound = UNNotificationSound.default

            // show this notification five seconds from `inicio`
            let startTrigger = UNTimeIntervalNotificationTrigger(timeInterval: startInterval, repeats: false)

            // choose a random identifier
            let startRequest = UNNotificationRequest(identifier: "MMLiveWillStart", content: start, trigger: startTrigger)

            // add our notification request
            UNUserNotificationCenter.current().add(startRequest)
        }

    }

    func endInterval(for event: MMLive) {
        let endInterval = event.fim.timeIntervalSince(Date())
        if endInterval > 0 {
            let end = UNMutableNotificationContent()
            end.title = "MM Live foi encerrado"
            end.subtitle = "Obrigado por nos acompanhar!"
            end.sound = UNNotificationSound.default

            // show this notification five seconds from `fim`
            let endTrigger = UNTimeIntervalNotificationTrigger(timeInterval: endInterval, repeats: false)

            // choose a random identifier
            let endRequest = UNNotificationRequest(identifier: "MMLiveEnded", content: end, trigger: endTrigger)

            // add our notification request
            UNUserNotificationCenter.current().add(endRequest)
        }
    }
}

extension PushNotification: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
