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
	func scrollViewDidScroll(_ scrollView: UIScrollView)
	func showActionSheet(items: [Any])
}

extension FetchedResultsControllerDelegate {
	func willDisplayCell(indexPath: IndexPath) {}
	func didSelectRowAt(indexPath: IndexPath) {}
}

class FetchedResultsControllerDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

	// MARK: - Properties -

	weak var delegate: FetchedResultsControllerDelegate?

	fileprivate var tableView: UITableView?
    fileprivate let managedObjectContext = CoreDataStack.shared.viewContext
    fileprivate var groupedBy: String?

    public let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()

	fileprivate lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Post> in
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

	// MARK: - Scroll detection -

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		delegate?.scrollViewDidScroll(scrollView)
	}

	// MARK: - TableView methods -

	func numberOfSections(in tableView: UITableView) -> Int {
		return sections()
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let sections = fetchedResultsController.sections else {
			return nil
		}
		let currentSection = sections[section]
		return currentSection.name.isEmpty ? nil : currentSection.name.toHeaderDate()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rows(in: section)
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let favoritar = UIContextualAction(style: .normal, title: nil) {
			_, _, boolValue in

			let object = self.fetchedResultsController.object(at: indexPath)
			object.favorite = !object.favorite
			CoreDataStack.shared.save()

			boolValue(true)
		}
		favoritar.backgroundColor = UIColor(hex: "0097d4", alpha: 1)
		favoritar.image = UIImage(named: "fav_cell")

		let compatilhar = UIContextualAction(style: .normal, title: nil) {
			_, _, boolValue in

			let post = self.fetchedResultsController.object(at: indexPath)
			guard let link = post.link,
				let url = URL(string: link)
				else {
					boolValue(true)
					return
			}

			let items: [Any] = [post.title ?? "", url]
			self.delegate?.showActionSheet(items: items)

			boolValue(true)
		}
		compatilhar.backgroundColor = UIColor(hex: "0097d4", alpha: 1)
		compatilhar.image = UIImage(named: "share")

		return UISwipeActionsConfiguration(actions: [compatilhar, favoritar])
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		delegate?.willDisplayCell(indexPath: indexPath)
	}

	internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var identifier = "normalCell"
		let object = fetchedResultsController.object(at: indexPath)
		if object.categorias?.contains("Destaques") ?? false {
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
		@unknown default:
			break
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView?.endUpdates()
	}

	// MARK: -

	func hasData() -> Bool {
		return !(fetchedResultsController.fetchedObjects?.isEmpty ?? true)
	}

	func sections() -> Int {
		guard let sections = self.fetchedResultsController.sections else {
			return 0
		}
		return sections.count
	}

	func rows(in section: Int) -> Int {
		guard let sections = self.fetchedResultsController.sections else {
			return 0
		}
		let sectionInfo = sections[section]
		return sectionInfo.numberOfObjects
	}

	func object(at indexPath: IndexPath) -> Post? {
		return fetchedResultsController.object(at: indexPath)
	}

	func links() -> [PostData] {
		guard let posts = fetchedResultsController.fetchedObjects else {
			return []
		}
		var response = [PostData]()
		for post in posts {
			response.append(PostData(title: post.title, link: post.link, thumbnail: post.artworkURL))
		}
		return response
	}

}
