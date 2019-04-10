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
