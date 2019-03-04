//
//  PostsMasterViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 18/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import CoreData
import Kingfisher
import UIKit

// MARK: - Extensions -

extension UITableView {
	func rowNumber(indexPath: IndexPath) -> Int {
		if indexPath.section == 0 {
			return indexPath.row
		}
		var rows = 0
		for i in 0...indexPath.section {
			if i == indexPath.section {
				rows += indexPath.row
				break
			}
			rows += self.numberOfRows(inSection: i)
		}
		return rows
	}
}

// MARK: - Enums -

enum Direction {
	case down
	case up
}

// MARK: -

class PostsMasterViewController: UITableViewController, FetchedResultsControllerDelegate {

	// MARK: - Properties -

	let managedObjectContext = DataController.sharedInstance.managedObjectContext
	var detailViewController: PostsDetailViewController?

	var lastContentOffset = CGPoint()
	var direction: Direction = .down
	var lastPage = -1

	var selectedIndexPath: IndexPath?

	// MARK: - View Lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 133

		getPosts(paged: 0)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).with {
			$0.textAlignment = .center
		}

		// Execute the fetch to display the data
		fetchedResultsController.reloadData()

		if fetchedResultsController.hasData() && !(self.refreshControl?.isRefreshing ?? true) {
			getPosts(paged: 0)
		}

		if self.refreshControl?.isRefreshing ?? true {
			self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.refreshControl?.frame.size.height ?? 88)), animated: true)
		}

		if UIDevice.current.userInterfaceIdiom == .phone {
			selectedIndexPath = nil
		}

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Fetched Results Controller Methods -

	lazy var fetchedResultsController: FetchedResultsControllerDataSource = {
		let fetchRequest: NSFetchRequest<Posts> = Posts.fetchRequest()

		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "headerDate", ascending: false),
										NSSortDescriptor(key: "pubDate", ascending: false)]
		fetchRequest.predicate = NSPredicate(format: "NOT categorias CONTAINS[cd] %@", "Podcast")

		// Initialize Fetched Results Controller
		let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "headerDate", cacheName: nil)

		do {
			try controller.performFetch()
		} catch {
			let fetchError = error as NSError
			print("\(fetchError), \(fetchError.userInfo)")
		}

		let fetchController = FetchedResultsControllerDataSource(withTable: self.tableView, fetchedResultsController: controller)
		fetchController.delegate = self

		return fetchController
	}()

	// MARK: - Scroll detection -

	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		direction = offset.y > lastContentOffset.y ? .down : .up
		lastContentOffset = offset
	}

	// MARK: - Segues -

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let indexPath = tableView.indexPathForSelectedRow {
			guard let navController = segue.destination as? UINavigationController,
				let controller = navController.topViewController as? PostsDetailViewController else {
					return
			}
			controller.navigationItem.leftItemsSupplementBackButton = true
			controller.post = fetchedResultsController.object(at: indexPath)
		}
	}

	// MARK: - View Methods -

	func configure(cell: PostCell, atIndexPath: IndexPath) {
		guard let object = fetchedResultsController.object(at: atIndexPath) else {
			return
		}
		cell.configurePost(object)
	}

	func willDisplayCell(indexPath: IndexPath) {
		if direction == .down {
			let page = Int(tableView.rowNumber(indexPath: indexPath) / 14) + 1
			if page >= lastPage && tableView.rowNumber(indexPath: indexPath) % 14 == 0 {
				lastPage = page
				self.getPosts(paged: page)
			}
		}
	}

	func didSelectRowAt(indexPath: IndexPath) {
		if selectedIndexPath != indexPath {
			self.performSegue(withIdentifier: "showDetail", sender: self)
		}
		selectedIndexPath = indexPath
	}

	@IBAction private func getPosts() {
		getPosts(paged: 0)
	}

	fileprivate func getPosts(paged: Int) {
		self.refreshControl?.beginRefreshing()

		let processResponse: (XMLPost?) -> Void = { post in
            guard let post = post else {
				DispatchQueue.main.async {
					self.refreshControl?.endRefreshing()
					self.fetchedResultsController.reloadData()
				}
				return
            }

			Posts.insertOrUpdatePost(post: post)
            DataController.sharedInstance.saveContext()
        }

		API().getPosts(page: paged, processResponse)
	}

}
