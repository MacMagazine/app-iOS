#if canImport(SafariServices)
#if canImport(UIKit)
import Foundation
import SafariServices
import UIKit
import SwiftUI

public class Utils {

    @MainActor
	static public func openInSafari(_ url: URL) {
		if url.scheme?.lowercased().contains("http") ?? false {
			let safari = SFSafariViewController(url: url)

			guard let controller = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
			controller.present(safari, animated: true, completion: nil)
		}
	}
}
#endif
#endif
