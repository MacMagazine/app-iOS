//
//  DateExtensions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 27/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Foundation

extension Date {

	func headerDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +0000"
		dateFormatter.locale = Locale(identifier: "en_US")
		return dateFormatter.string(from: self)
	}

	func cellDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		return dateFormatter.string(from: self)
	}

	func sortedDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyyMMdd"
		return dateFormatter.string(from: self)
	}

	func watchDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
		return dateFormatter.string(from: self)
	}

}
