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

	let timeLineText = ["Mensagem 1", "Mensagem 2", "Mensagem 3", "Mensagem 4"]

    // MARK: - Timeline Configuration -

    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.backward, .forward])
    }

    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date())
    }

    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
		let currentDate = Date()
		let endDate = currentDate.addingTimeInterval(TimeInterval(4 * 60))
		handler(endDate)
	}

    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population -

    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
		if complication.family == .modularLarge ||
            complication.family == .utilitarianLarge {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "hh:mm"

			let timeString = dateFormatter.string(from: Date())
            let entry = createTimeLineEntry(for: complication, headerText: timeString, bodyText: timeLineText[0], date: Date())

			handler(entry)
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
		var nextDate = Date(timeIntervalSinceNow: 1 * 60)

		for index in 1...3 {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "hh:mm"

			let timeString = dateFormatter.string(from: nextDate)
            guard let entry = createTimeLineEntry(for: complication, headerText: timeString, bodyText: timeLineText[index], date: nextDate) else {
                return
            }
			timeLineEntryArray.append(entry)
			nextDate = nextDate.addingTimeInterval(1 * 60)
		}
		handler(timeLineEntryArray)
    }

    // MARK: - Placeholder Templates -

    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        if complication.family == .modularLarge {
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Título inicial")
            template.body1TextProvider = CLKSimpleTextProvider(text: "Textinho inicial")
            handler(template)

        } else if complication.family == .utilitarianLarge {
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = CLKSimpleTextProvider(text: "Título inicial")
            handler(template)

        } else {
            handler(nil)
        }
	}

	// MARK: - Methods -

	func createTimeLineEntry(for complication: CLKComplication, headerText: String, bodyText: String, date: Date) -> CLKComplicationTimelineEntry? {

        if complication.family == .modularLarge {
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
            template.body1TextProvider = CLKSimpleTextProvider(text: bodyText)
            let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
            return(entry)

        } else if complication.family == .utilitarianLarge {
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = CLKSimpleTextProvider(text: bodyText)
            let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
            return(entry)
        } else {
            return nil
        }
	}

}
