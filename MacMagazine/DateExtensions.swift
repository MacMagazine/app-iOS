//
//  DateExtensions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 27/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Foundation

extension Date {

	func cellDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		dateFormatter.timeZone = TimeZone(abbreviation: "BRT")
		return dateFormatter.string(from: self)
	}

	func sortedDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyyMMdd"
		dateFormatter.timeZone = TimeZone(abbreviation: "BRT")
		return dateFormatter.string(from: self)
	}

	func watchDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
		dateFormatter.timeZone = TimeZone(abbreviation: "BRT")
		return dateFormatter.string(from: self)
	}

}
