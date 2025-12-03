import Foundation

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
