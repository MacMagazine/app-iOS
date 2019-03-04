//
//  PodcastMasterViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 01/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import CoreData
import UIKit

class PodcastMasterViewController: UITableViewController, FetchedResultsControllerDelegate {

	// MARK: - Properties -

	let managedObjectContext = DataController.sharedInstance.managedObjectContext
	var detailViewController: PostsDetailViewController?

	var lastContentOffset = CGPoint()
	var direction: Direction = .down
	var lastPage = -1

	// MARK: - View Lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 133

		getPodcasts(paged: 0)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Execute the fetch to display the data
		fetchedResultsController.reloadData()

		if fetchedResultsController.hasData() && !(self.refreshControl?.isRefreshing ?? true) {
			getPodcasts(paged: 0)
		}

		if self.refreshControl?.isRefreshing ?? true {
			self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.refreshControl?.frame.size.height ?? 88)), animated: true)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Segues -

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
			if let indexPath = tableView.indexPathForSelectedRow {
				guard let navController = segue.destination as? UINavigationController else {
					return
				}
				guard let controller = navController.topViewController as? PostsDetailViewController else {
					return
				}
				controller.post = fetchedResultsController.object(at: indexPath)
			}
		}
	}

	// MARK: - Fetched Results Controller Methods -

	lazy var fetchedResultsController: FetchedResultsControllerDataSource = {
		let fetchRequest: NSFetchRequest<Posts> = Posts.fetchRequest()

		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]
		fetchRequest.predicate = NSPredicate(format: "categorias CONTAINS[cd] %@", "Podcast")

		// Initialize Fetched Results Controller
		let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

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

	// MARK: - View Methods -

	func configure(cell: PostCell, atIndexPath: IndexPath) {
		guard let object = fetchedResultsController.object(at: atIndexPath) else {
			return
		}
		cell.configurePodcast(object)
	}

	func willDisplayCell(indexPath: IndexPath) {
		if direction == .down {
			let page = Int(tableView.rowNumber(indexPath: indexPath) / 14) + 1
			if page >= lastPage && tableView.rowNumber(indexPath: indexPath) % 14 == 0 {
				lastPage = page
				self.getPodcasts(paged: page)
			}
		}
	}

	@IBAction private func getPodcasts() {
		getPodcasts(paged: 0)
	}

	fileprivate func getPodcasts(paged: Int) {

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
		API().getPodcasts(page: paged, processResponse)
	}
}
