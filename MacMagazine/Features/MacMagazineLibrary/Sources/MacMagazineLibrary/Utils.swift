import Foundation
import SwiftUI

public class Utils {
    static public let userAgent = "/MacMagazine"
}

#if os(iOS) || os(visionOS)
import UIKit

public extension Utils {
    @MainActor
    static func isDarkMode(for colorSchema: ColorScheme?) -> Bool {
        if colorSchema == nil {
            (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .windows.first?
                .rootViewController?
                .traitCollection.userInterfaceStyle == .dark
        } else {
            colorSchema == .dark
        }
    }
}
#else
public extension Utils {
    @MainActor
    static func isDarkMode() -> Bool {
        false
    }
}
#endif

#if canImport(SafariServices)
import SafariServices

public extension Utils {
    @MainActor
    static func openInSafari(_ url: URL) {
        if url.scheme?.lowercased().contains("http") ?? false {
            let safari = SFSafariViewController(url: url)

            guard let controller = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
            controller.present(safari, animated: true, completion: nil)
        }
    }
}
#endif
