import CommonLibrary
import Foundation

extension URL {

	var isMMAddress: Bool {
		return self.absoluteString.prefix(APIParams.mainURL.count) == APIParams.mainURL
	}

	var isMMPost: Bool {
		return isMMAddress && self.absoluteString.contains("/post/")
	}

	var isAppStore: Bool {
		return self.absoluteString.contains("apps.apple.com") ||
		self.absoluteString.contains("itunes.apple.com")
	}

	var isYouTube: Bool {
		let youTubeURL = "https://www.youtube.com/"
		return self.absoluteString.prefix(youTubeURL.count) == youTubeURL
	}

	var isAppStoreBadge: Bool {
		return self.absoluteString.contains("badge_appstore") ||
		self.absoluteString.contains("badge_macappstore")
	}

	var appStoreId: String? {
		var id: String?
		let components = self.absoluteString.split(separator: "/")
		if let lastComponent = components.last {
			let splittedComponents = lastComponent.split(separator: "?")
			splittedComponents.forEach { component in
				if component.contains("id") {
					id = component.replacingOccurrences(of: "id", with: "")
				}
			}
		}
		return id
	}

	var videoId: String? {
		let queryItems = URLComponents(string: self.absoluteString)?.queryItems
		return queryItems?.first(where: { $0.name == "v" })?.value
	}
}

extension String {
	var escaped: String {
		guard let escapedString = self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
			return ""
		}
		return escapedString
	}

	var htmlDecoded: String {
		let decoded = try? NSAttributedString(data: Data(utf8),
											  options: [.documentType: NSAttributedString.DocumentType.html,
														.characterEncoding: String.Encoding.utf8.rawValue],
											  documentAttributes: nil)
			.string
			.replacingOccurrences(of: "&#8230;", with: "...")

		return decoded ?? self
	}

	var clean: String {
		self
			.replacingOccurrences(of: "\n\n", with: "\n")
			.replacingOccurrences(of: "\n\n", with: "\n")
			.replacingOccurrences(of: "\n\n", with: "\n")
			.replacingOccurrences(of: "\n\n", with: "\n")
			.replacingOccurrences(of: "\n\n", with: "\n")
	}

	var decodedHTMLString: String {
		guard let encodedData = self.data(using: String.Encoding.utf8) else {
			return ""
		}
		do {
			return try NSAttributedString(data: encodedData,
										  options: [.documentType: NSAttributedString.DocumentType.html,
													.characterEncoding: String.Encoding.utf8.rawValue],
										  documentAttributes: nil).string
		} catch {
			return error.localizedDescription
		}
	}
}
