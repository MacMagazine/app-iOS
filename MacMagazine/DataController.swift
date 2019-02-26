//
//  DataController.swift
//
//  Created by Cassio Rossi on 8/25/16.
//  Copyright © 2016 Cassio Rossi. All rights reserved.
//

import CoreData
import UIKit

class DataController: NSObject {

	// MARK: - Singleton -

	static let sharedInstance = DataController()

	// MARK: - Properties -

	var managedObjectContext: NSManagedObjectContext
	var privateManagedObjectContext: NSManagedObjectContext

	let db = "macmagazine"

	// MARK: - Core Data stack -

	private override init() {

		// This resource is the same name as your xcdatamodeld contained in your project.
		guard let modelURL = Bundle.main.url(forResource: self.db, withExtension: "momd") else {
			fatalError("Error loading model from bundle")
		}

		// The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
		guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
			fatalError("Error initializing mom from: \(modelURL)")
		}

		// Create a managed context to be used on the main thread and a private to be used on other threads
		let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
		self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

		self.privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		self.privateManagedObjectContext.parent = self.managedObjectContext

		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let docURL = urls[urls.endIndex - 1]

		/* The directory the application uses to store the Core Data store file.
		This code uses a file named "DataModel.sqlite" in the application's documents directory.
		*/
		let storeURL = docURL.appendingPathComponent("\(self.db).sqlite")
		do {
			// options allow the database to be versioned
			let options = [NSMigratePersistentStoresAutomaticallyOption: true,
						   NSInferMappingModelAutomaticallyOption: true]
			try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
		} catch {
			fatalError("Error migrating store: \(error)")
		}

	}

	// MARK: - Core Data Saving support -

	func saveContext () {
		do {
			try self.privateManagedObjectContext.save()
			self.managedObjectContext.perform {
				do {
					try self.managedObjectContext.save()
				} catch let err as NSError {
					print("Could not save main context: \(err.localizedDescription)")
				}
			}
		} catch let err as NSError {
			print("Could not save private context: \(err.localizedDescription)")
		}
	}

}
