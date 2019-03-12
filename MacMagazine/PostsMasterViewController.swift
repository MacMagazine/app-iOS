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

class PostsMasterViewController: UITableViewController, FetchedResultsControllerDelegate, ResultsViewControllerDelegate {

	// MARK: - Properties -

	let managedObjectContext = DataController.sharedInstance.managedObjectContext
	var detailViewController: PostsDetailViewController?

	var lastContentOffset = CGPoint()
	var direction: Direction = .down
	var lastPage = -1

	var selectedIndexPath: IndexPath?

	private var searchController: UISearchController?
	private var resultsTableController: ResultsViewController?
	var posts = [XMLPost]()

	// MARK: - View Lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		resultsTableController = ResultsViewController()
		resultsTableController?.delegate = self
		resultsTableController?.tableView.delegate = self
		resultsTableController?.isPodcast = false

		searchController = UISearchController(searchResultsController: resultsTableController)
		searchController?.searchBar.autocapitalizationType = .none
		searchController?.searchBar.delegate = self
		searchController?.searchBar.placeholder = "Procurar nos Posts ..."
		tableView.tableHeaderView = searchController?.searchBar
		self.definesPresentationContext = true

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 133

		getPosts(paged: 0)
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = true
		super.viewWillAppear(animated)

		UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).with {
			$0.textAlignment = .center
		}
		if UIDevice.current.userInterfaceIdiom == .phone {
			selectedIndexPath = nil
		}

		// Execute the fetch to display the data
		fetchedResultsController.reloadData()

		if fetchedResultsController.hasData() && !(self.refreshControl?.isRefreshing ?? true) {
			getPosts(paged: 0)
		}

		if self.refreshControl?.isRefreshing ?? true {
			self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.refreshControl?.frame.size.height ?? 88)), animated: true)
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		processSelection()
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
			selectedIndexPath = indexPath
			UserDefaults.standard.set(["row": indexPath.row, "section": indexPath.section], forKey: "selectedIndexPath")
			UserDefaults.standard.synchronize()
		}
	}

	func configure(cell: PostCell, atIndexPath: IndexPath) {
		guard let object = fetchedResultsController.object(at: atIndexPath) else {
			return
		}
		cell.configurePost(object)
	}

	func configureResult(cell: PostCell, atIndexPath: IndexPath) {
		if !posts.isEmpty {
			let object = posts[atIndexPath.row]
			cell.configureSearchPost(object)
		}
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
					self.processSelection()
				}
				return
            }

			Posts.insertOrUpdatePost(post: post)
            DataController.sharedInstance.saveContext()
        }

		API().getPosts(page: paged, processResponse)
	}

	fileprivate func processSelection() {
		if UIDevice.current.userInterfaceIdiom == .pad {
			guard let dict = UserDefaults.standard.object(forKey: "selectedIndexPath") as? [String: Int] else {
				self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
				self.fetchedResultsController.tableView(self.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
				return
			}
			let indexPath = IndexPath(row: dict["row"] ?? 0, section: dict["section"] ?? 0)
			self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
			fetchedResultsController.tableView(tableView, didSelectRowAt: indexPath)
		}
	}

	fileprivate func isFiltering() -> Bool {
		return searchController?.isActive ?? false
	}

	fileprivate func searchPosts(_ text: String) {
		let processResponse: (XMLPost?) -> Void = { post in
			guard let post = post else {
				DispatchQueue.main.async {
					self.posts.sort(by: {
						$0.pubDate.toDate(nil).sortedDate().compare($1.pubDate.toDate(nil).sortedDate()) == .orderedDescending
					})
					self.resultsTableController?.posts = self.posts
					self.resultsTableController?.tableView.reloadData()
				}
				return
			}
			self.posts.append(post)
		}
		posts = []
		API().searchPosts(text, processResponse)
	}

}

// MARK: - UISearchBarDelegate -

extension PostsMasterViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text else {
			return
		}
		searchPosts(text)
		searchBar.resignFirstResponder()
	}
}
