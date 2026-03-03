import Foundation

extension String {
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

}
