//
//  StringExtensions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 27/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Foundation

extension String {

	func toDate() -> Date {
		return toDate(nil)
	}

	func toDate(_ format: String?) -> Date {
        // Expected date format: "Tue, 26 Feb 2019 23:00:53 +0000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? "EEE, dd MMM yyyy HH:mm:ss +0000"
		dateFormatter.locale = Locale(identifier: "en_US")
		dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: self) ?? Date()
    }

	func toHeaderDate() -> String {
		// Expected date format: "20190227"
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyyMMdd"
		dateFormatter.timeZone = TimeZone(abbreviation: "BRT")
		let date = dateFormatter.date(from: self) ?? Date()

		let calendar = Calendar.current
		if calendar.isDateInToday(date) {
			return "HOJE"
		}
		if calendar.isDateInYesterday(date) {
			return "ONTEM"
		}
		dateFormatter.locale = Locale(identifier: "pt-BR")
		dateFormatter.dateFormat = "EEEE, dd 'DE' MMMM"
		return dateFormatter.string(from: date).uppercased()
	}

	func toComplicationDate() -> String {
		// Expected date format: "20190227"
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyyMMdd"
		dateFormatter.timeZone = TimeZone(abbreviation: "BRT")
		let day = dateFormatter.date(from: self) ?? Date()

		let calendar = Calendar.current
		if calendar.isDateInToday(day) {
			dateFormatter.dateFormat = "'@'HH:mm"
		} else if calendar.isDateInYesterday(day) {
			dateFormatter.dateFormat = "'ONTEM @'HH:mm"
		} else {
			dateFormatter.dateFormat = "dd/MM' @'HH:mm"
		}
		dateFormatter.locale = Locale(identifier: "pt-BR")

		let date = dateFormatter.date(from: self) ?? Date()
		return dateFormatter.string(from: date).uppercased()
	}

	func escape() -> String {
		guard let escapedString = self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
			return ""
		}
		return escapedString
	}
}
