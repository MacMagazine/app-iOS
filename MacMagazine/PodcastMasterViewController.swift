//
//  PodcastMasterViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 01/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import CoreData
import UIKit

class PodcastMasterViewController: UITableViewController, FetchedResultsControllerDelegate, ResultsViewControllerDelegate {

	// MARK: - Properties -

    var fetchController: FetchedResultsControllerDataSource?
	var detailViewController: PostsDetailViewController?

	var lastContentOffset = CGPoint()
	var direction: Direction = .up
	var lastPage = -1

	private var searchController: UISearchController?
	private var resultsTableController: ResultsViewController?
	var posts = [XMLPost]()

    var showFavorites = false
    let categoryPredicate = NSPredicate(format: "categorias CONTAINS[cd] %@", "Podcast")
    let favoritePredicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))

	// MARK: - View Lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
        fetchController = FetchedResultsControllerDataSource(withTable: self.tableView, group: nil, featuredCellNib: "PodcastCell")
        fetchController?.delegate = self
        fetchController?.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]
        fetchController?.fetchRequest.predicate = categoryPredicate

		resultsTableController = ResultsViewController()
		resultsTableController?.delegate = self
		resultsTableController?.isPodcast = true

		searchController = UISearchController(searchResultsController: resultsTableController)
		searchController?.searchBar.autocapitalizationType = .none
		searchController?.searchBar.delegate = self
		searchController?.searchBar.placeholder = "Buscar nos Podcasts ..."
		tableView.tableHeaderView = searchController?.searchBar

		self.definesPresentationContext = true

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 133

		// Execute the fetch to display the data
		fetchController?.reloadData()

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
			self.getPodcasts(paged: 0)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Scroll detection -

	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		direction = offset.y > lastContentOffset.y ? .down : .up
		lastContentOffset = offset
	}

	// MARK: - View Methods -

	func showActionSheet(_ view: UIView?, for items: [Any]) {
		let customItem = UIActivityExtensions(title: "Favoritar", image: UIImage(named: "fav_cell")) { items in
			for item in items {
				guard let post = self.fetchController?.object(with: "\(item)") else {
					continue
				}
				post.favorite = !post.favorite
				CoreDataStack.shared.save()
			}
		}

		let activityVC = UIActivityViewController(activityItems: items, applicationActivities: [customItem])
		if let ppc = activityVC.popoverPresentationController {
			guard let view = view else {
				return
			}
			ppc.sourceView = view
		}
		present(activityVC, animated: true)
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

	func configure(cell: PostCell, atIndexPath: IndexPath) {
		guard let object = fetchController?.object(at: atIndexPath) else {
			return
		}
		cell.configurePodcast(object)
	}

	func configureResult(cell: PostCell, atIndexPath: IndexPath) {
		if !posts.isEmpty {
			let object = posts[atIndexPath.row]
			cell.configureSearchPodcast(object)
		}
	}

	// MARK: - Actions methods -

	@IBAction private func getPodcasts() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
			self.getPodcasts(paged: 0)
		}
	}

    @IBAction private func showFavorites(_ sender: Any) {
        showFavorites = !showFavorites
        if showFavorites {
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, favoritePredicate])
            fetchController?.fetchRequest.predicate = predicate
        } else {
            fetchController?.fetchRequest.predicate = categoryPredicate
        }
        fetchController?.reloadData()
        tableView.reloadData()
    }

    // MARK: - Local methods -

    fileprivate func hasData() -> Bool {
        return (fetchController?.hasData() ?? false) && !(self.refreshControl?.isRefreshing ?? true)
    }

	fileprivate func getPodcasts(paged: Int) {
		if paged < 1 {
			self.refreshControl?.beginRefreshing()
			self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.refreshControl?.frame.size.height ?? 88)), animated: true)
		}

		API().getPodcasts(page: paged) { post in
			DispatchQueue.main.async {
				guard let post = post else {
					// When post == nil, indicates the last post retrieved
					self.fetchController?.reloadData()
					if paged < 1 {
						self.refreshControl?.endRefreshing()
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
							self.tableView.setContentOffset(CGPoint(x: 0, y: 56), animated: true)
						}
					}
					return
				}
				CoreDataStack.shared.save(post: post)
			}
		}
	}

	fileprivate func isFiltering() -> Bool {
		return searchController?.isActive ?? false
	}

	fileprivate func searchPodcasts(_ text: String) {
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
		API().searchPodcasts(text, processResponse)
	}

}

// MARK: - UISearchBarDelegate -

extension PodcastMasterViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text else {
			return
		}
		searchPodcasts(text)
		searchBar.resignFirstResponder()
	}
}
