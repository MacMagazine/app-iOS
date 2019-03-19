//
//  FetchedResultsControllerDataSource.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 04/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import CoreData
import UIKit

protocol FetchedResultsControllerDelegate: AnyObject {
	func willDisplayCell(indexPath: IndexPath)
	func didSelectRowAt(indexPath: IndexPath)
	func configure(cell: PostCell, atIndexPath: IndexPath)
}

extension FetchedResultsControllerDelegate {
	func willDisplayCell(indexPath: IndexPath) {}
	func didSelectRowAt(indexPath: IndexPath) {}
}

class FetchedResultsControllerDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

	// MARK: - Properties -

	weak var delegate: FetchedResultsControllerDelegate?

	fileprivate var tableView: UITableView?
    fileprivate let managedObjectContext = DataController.sharedInstance.managedObjectContext
    fileprivate var groupedBy: String?

    public let fetchRequest: NSFetchRequest<Posts> = Posts.fetchRequest()

	fileprivate lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Posts> in
		// Initialize Fetched Results Controller
		let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		controller.delegate = self

		return controller
	}()

	// MARK: - Initialization methods -

    init(withTable tableView: UITableView, group: String?, featuredCellNib: String) {
        super.init()
        self.groupedBy = group
        setup(tableView: tableView)
        self.tableView?.register(UINib(nibName: featuredCellNib, bundle: nil), forCellReuseIdentifier: "featuredCell")
    }

    func setup(tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "normalCell")
    }

	// MARK: - TableView methods -

	func numberOfSections(in tableView: UITableView) -> Int {
		if let sections = self.fetchedResultsController.sections {
			return sections.count
		}
		return 0
	}

	private func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let sections = fetchedResultsController.sections {
			let currentSection = sections[section]
			return currentSection.name.toHeaderDate()
		}
		return nil
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = self.fetchedResultsController.sections {
			let sectionInfo = sections[section]
			return sectionInfo.numberOfObjects
		}
		return 0
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let favoritar = UIContextualAction(style: .normal, title: "Favoritar") {
			_, _, boolValue in

			let object = self.fetchedResultsController.object(at: indexPath)
			object.favorite = !object.favorite
			DataController.sharedInstance.saveContext()

			boolValue(true)
		}

		let compatilhar = UIContextualAction(style: .normal, title: "Compartilhar") {
			_, _, boolValue in

			boolValue(true)
		}

		return UISwipeActionsConfiguration(actions: [compatilhar, favoritar])
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		delegate?.willDisplayCell(indexPath: indexPath)
	}

	internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var identifier = "normalCell"
		let object = fetchedResultsController.object(at: indexPath)
		if object.categorias.contains("Destaques") {
			identifier = "featuredCell"
		}

		guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PostCell else {
			fatalError("Unexpected Index Path")
		}
		delegate?.configure(cell: cell, atIndexPath: indexPath)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.didSelectRowAt(indexPath: indexPath)
	}

	// MARK: - FetchController Delegate methods -

	func reloadData() {
		// Execute the fetch to display the data
		do {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: groupedBy, cacheName: nil)
            fetchedResultsController.delegate = self

            try fetchedResultsController.performFetch()
		} catch {
			print("An error occurred")
		}
	}

	func hasData() -> Bool {
		return !(fetchedResultsController.fetchedObjects?.isEmpty ?? true)
	}

	func object(at indexPath: IndexPath) -> Posts? {
		return fetchedResultsController.object(at: indexPath)
	}

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView?.beginUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

		switch type {
		case .insert:
			tableView?.insertSections(IndexSet(integer: sectionIndex), with: .fade)
		case .delete:
			tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
		default:
			return
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

		switch type {
		case .update:
			if let indexPath = indexPath {
				if let cell = tableView?.cellForRow(at: indexPath) as? PostCell {
					delegate?.configure(cell: cell, atIndexPath: indexPath)
				}
			}
		case .insert:
			if let indexPath = newIndexPath {
				tableView?.insertRows(at: [indexPath], with: .fade)
			}
		case .delete:
			if let indexPath = indexPath {
				tableView?.deleteRows(at: [indexPath], with: .fade)
			}
		case .move:
			if let indexPath = indexPath {
				tableView?.deleteRows(at: [indexPath], with: .fade)
			}
			if let newIndexPath = newIndexPath {
				tableView?.insertRows(at: [newIndexPath], with: .fade)
			}
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView?.endUpdates()
	}

}
