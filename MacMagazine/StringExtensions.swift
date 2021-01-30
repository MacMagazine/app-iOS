//
//  StringExtensions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 27/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

enum Format: CaseIterable {
	static let wordpress = "EEE, dd MMM yyyy HH:mm:ss +0000"
    static let youtube = "yyyy-MM-dd'T'HH:mm:ss'Z'"
}

extension String {

	func toDate(_ format: String? = nil) -> Date {
        // Expected date format: "Tue, 26 Feb 2019 23:00:53 +0000"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = format ?? Format.wordpress
        return dateFormatter.date(from: self.replacingOccurrences(of: ".000", with: "")) ?? Date()
    }

    fileprivate func currentCalendar() -> Calendar {
        var calendar = Calendar.current
        if let timeZone = TimeZone(identifier: "America/Sao_Paulo") {
            calendar.timeZone = timeZone
        }
        return calendar
    }

    func toHeaderDate(with dateFormat: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = dateFormat
		dateFormatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
		let date = dateFormatter.date(from: self) ?? Date()

		let calendar = currentCalendar()
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

    func setHeaderDateAccessibility() -> String {
        if self == "HOJE" {
            return "Posts de Hoje."
        } else if self == "ONTEM" {
            return "Posts de Ontem."
        } else {
            return "Posts de \(self)."
        }
    }

    func toAccessibilityTime() -> String {
        let array = self.split { $0 == ":" }.map( String.init )

        if array.count == 3 {
            let hours = array[0]
            let minutes = array[1]
            let seconds = array[2]

            return "\(getHoursString(string: hours))\(getMinutesString(string: minutes, elementsQuantity: 3))\(getSecondsString(string: seconds))"
        } else if array.count == 2 {
            let minutes = array[0]
            let seconds = array[1]

            return "\(getMinutesString(string: minutes, elementsQuantity: 2))\(getSecondsString(string: seconds))"
        } else {
            let seconds = array[0]

            return "\(getSecondsString(string: seconds))"
        }
    }

    func toAccessibilityDateAndTime() -> String {
        let array = self.split { $0 == " " }.map( String.init )

        // Expected format: "dd/MM/yyyy HH:mm"
        guard array.count == 2 else {
            return ""
        }

        let date = array[0]
        let time = "\(array[1]):00"     // format is HH:mm and accessibility expects HH:mm:ss

        return "Video postado em: \(date.toHeaderDate(with: "dd/MM/yyyy")), \(time.toAccessibilityTime())."
    }

    private func getHoursString(string: String) -> String {
        if Int(string) == 1 {
            return "Uma hora"
        } else {
            return "\(string) horas"
        }
    }

    private func getMinutesString(string: String, elementsQuantity: Int) -> String {
        if Int(string) == 0 {
            return " "
        } else if Int(string) == 1 {
            return elementsQuantity == 2 ? "Um minuto" : ", Um minuto"
        } else {
            return elementsQuantity == 2 ? "\(string) minutos" : ", \(string) minutos"
        }
    }

    private func getSecondsString(string: String) -> String {
        if Int(string) == 0 {
            return "."
        } else if Int(string) == 1 {
            return " e um segundo."
        } else {
            return " e \(string) segundos."
        }
    }

	func toComplicationDate() -> String {
		let dateToUse = self.toDate()

        let calendar = currentCalendar()
		let day = String(format: "%02d", calendar.component(.day, from: dateToUse))
		let month = String(format: "%02d", calendar.component(.month, from: dateToUse))
		let hour = String(format: "%02d", calendar.component(.hour, from: dateToUse))
		let minutes = String(format: "%02d", calendar.component(.minute, from: dateToUse))

		if calendar.isDateInToday(dateToUse) {
			return "HOJE \(hour):\(minutes)"
		} else if calendar.isDateInYesterday(dateToUse) {
			return "ONTEM \(hour):\(minutes)"
		}
		return "\(day)/\(month) \(hour):\(minutes)"
	}

	func escape() -> String {
		guard let escapedString = self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
			return ""
		}
		return escapedString
	}

	func toHtmlDecoded() -> String {
		let decoded = try? NSAttributedString(data: Data(utf8), options: [
			.documentType: NSAttributedString.DocumentType.html,
			.characterEncoding: String.Encoding.utf8.rawValue
			], documentAttributes: nil).string

		return decoded ?? self
	}

	func toSubHeaderDate() -> String {
		// Expected date format: "PT4M13S"
		// PT = fixed
		// 4M = 4 minutes
		// 13S = 13 seconds
		let formattedDuration = self
			.replacingOccurrences(of: "PT", with: "")
			.replacingOccurrences(of: "H", with: ":")
			.replacingOccurrences(of: "M", with: ":")
			.replacingOccurrences(of: "S", with: "")

        let components = formattedDuration.components(separatedBy: ":")
        var duration = ""
        for component in components {
            let value = Int(component) ?? 0
            duration = duration.isEmpty ? duration : duration + ":"
            duration += String(format: "%02d", value)
        }

        return duration
	}

    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize,
                                           options: [.usesLineFragmentOrigin, .usesFontLeading],
                                           attributes: [.font: font],
                                           context: nil)
        return actualSize.height
    }

    func formattedNumber() -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        guard let value = Int(self) else {
            return ""
        }
        let valueNumber = NSNumber(value: value)
        let number = formatter.string(from: valueNumber)
        return number ?? ""
    }

    func llamaCase() -> String {
        return "\(self.first?.lowercased() ?? "")\(self.dropFirst())"
    }
}
