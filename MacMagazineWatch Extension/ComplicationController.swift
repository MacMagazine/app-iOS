//
//  ComplicationController.swift
//  MacMagazineWatch Extension
//
//  Created by Cassio Rossi on 08/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {

	// MARK: - Properties -

	var posts: [XMLPost]?

	struct Complication {
		var header: String?
		var line1: String?
		var line2: String?

		init(header: String?, line1: String?, line2: String) {
			self.header = header
			self.line1 = line1
			self.line2 = line2
		}
	}

    // MARK: - Timeline Configuration -

    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.backward, .forward])
    }

    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date())
    }

    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
		let currentDate = Date()
		let endDate = currentDate.addingTimeInterval(TimeInterval(15 * 30))
		handler(endDate)
	}

    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population -

    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
		if complication.family == .modularLarge ||
            complication.family == .utilitarianLarge ||
			complication.family == .graphicRectangular {

			posts = []
			API().getPosts(page: 0) { post in
				guard let post = post else {
					return
				}
				if self.posts?.isEmpty ?? true {
					let dateFormatter = DateFormatter()
					dateFormatter.dateFormat = "hh:mm:ss"

					let timeString = dateFormatter.string(from: Date())
					let message = Complication(header: timeString, line1: post.title, line2: post.pubDate)
					let entry = self.createTimeLineEntry(for: complication, message: message, date: Date())
					handler(entry)
				}
				self.posts?.append(post)
			}

		} else {
			handler(nil)
		}
    }

    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
		handler(nil)
	}

    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {

        // Call the handler with the timeline entries after to the given date
		var timeLineEntryArray = [CLKComplicationTimelineEntry]()
		var nextDate = Date(timeIntervalSinceNow: 10)

		guard let posts = posts else {
			return
		}
		for post in posts {
			print("==== \(post.title)")
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "hh:mm:ss"

			let timeString = dateFormatter.string(from: nextDate)
			let message = Complication(header: timeString, line1: post.title, line2: post.pubDate)
            guard let entry = createTimeLineEntry(for: complication, message: message, date: nextDate) else {
				handler(nil)
                return
            }
			timeLineEntryArray.append(entry)
			nextDate = nextDate.addingTimeInterval(10)
		}
		handler(timeLineEntryArray)
    }

    // MARK: - Placeholder Templates -

    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
		let message = Complication(header: "MacMagazine", line1: "Sem conteúdo", line2: "")
		let entry = createComplicationTemplate(for: complication, message: message)
		handler(entry)
	}

	// MARK: - Methods -

	func createComplicationTemplate(for complication: CLKComplication, message: Complication) -> CLKComplicationTemplate? {

		if complication.family == .modularLarge {
			let template = CLKComplicationTemplateModularLargeStandardBody()
			template.headerTextProvider = CLKSimpleTextProvider(text: message.header ?? "")
			template.body1TextProvider = CLKSimpleTextProvider(text: message.line1 ?? "")
			template.body2TextProvider = CLKSimpleTextProvider(text: message.line2 ?? "")
			return(template)

		} else if complication.family == .utilitarianLarge {
			let template = CLKComplicationTemplateUtilitarianLargeFlat()
			template.textProvider = CLKSimpleTextProvider(text: message.line1 ?? "")
			return(template)

		} else if complication.family == .graphicRectangular {
			let template = CLKComplicationTemplateGraphicRectangularStandardBody()
			template.headerTextProvider = CLKSimpleTextProvider(text: message.header ?? "")
			template.body1TextProvider = CLKSimpleTextProvider(text: message.line1 ?? "")
			template.body2TextProvider = CLKSimpleTextProvider(text: message.line2 ?? "")
			return(template)

		} else {
			return nil
		}
	}

	func createTimeLineEntry(for complication: CLKComplication, message: Complication, date: Date) -> CLKComplicationTimelineEntry? {
		guard let template = createComplicationTemplate(for: complication, message: message) else {
			return nil
		}

		let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
		return(entry)
	}

	func reloadData() {
		let server = CLKComplicationServer.sharedInstance()
		guard let complications = server.activeComplications,
			!complications.isEmpty else {
				return
		}

		for complication in complications {
			server.reloadTimeline(for: complication)
		}
	}

}
