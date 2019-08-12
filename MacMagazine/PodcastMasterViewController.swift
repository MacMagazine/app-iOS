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

	var searchController: UISearchController?
	var resultsTableController: ResultsViewController?
	var posts = [XMLPost]()

    var showFavorites = false
    let categoryPredicate = NSPredicate(format: "categorias CONTAINS[cd] %@", "Podcast")
	let isPodcastPredicate = NSPredicate(format: "podcastURL CONTAINS[cd] %@", "http")
    let favoritePredicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))

    var play: ((Podcast?) -> Void)?
	var selectedIndex: IndexPath?

    var showSpin: (() -> Void)?
    var hideSpin: (() -> Void)?

	// MARK: - View Lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		NotificationCenter.default.addObserver(self, selector: #selector(onScrollToTop(_:)), name: .scrollToTop, object: nil)

		fetchController = FetchedResultsControllerDataSource(withTable: self.tableView, group: nil, featuredCellNib: "PodcastCell")
        fetchController?.delegate = self
		fetchController?.filteringFavorite = false
        fetchController?.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]
		let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, isPodcastPredicate])
		fetchController?.fetchRequest.predicate = predicate

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 200

		// Execute the fetch to display the data
		fetchController?.reloadData()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if !hasData() {
			getPodcasts(paged: 0)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Scroll detection -

	@objc func onScrollToTop(_ notification: Notification) {
		tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
		tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: false)
	}

	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		direction = offset.y > lastContentOffset.y ? .down : .up
		lastContentOffset = offset

        // Pull to Refresh
        if offset.y < -100 {
            self.getPodcasts(paged: 0)
        }
	}

	// MARK: - View Methods -

	func showActionSheet(_ view: UIView?, for items: [Any]) {
		Share().present(at: view, using: items)
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

    func didSelectRowAt(indexPath: IndexPath) {
		if selectedIndex == indexPath {
        	tableView.deselectRow(at: indexPath, animated: true)
			selectedIndex = nil
		}
		selectedIndex = indexPath

		guard let object = fetchController?.object(at: indexPath) else {
                return
		}
		let podcast = Podcast(title: object.title, duration: object.duration, url: object.podcastURL, frame: object.podcastFrame)
		play?(podcast)
    }

    func configureResult(cell: PostCell, atIndexPath: IndexPath) {
        if !posts.isEmpty {
            let object = posts[atIndexPath.row]
            cell.configureSearchPodcast(object)
        }
    }

    func didSelectResultRowAt(indexPath: IndexPath) {
		if selectedIndex == indexPath {
			tableView.deselectRow(at: indexPath, animated: true)
			selectedIndex = nil
		}
		selectedIndex = indexPath

		let object = posts[indexPath.row]
		let podcast = Podcast(title: object.title, duration: object.duration, url: object.podcastURL, frame: object.podcastFrame)
		play?(podcast)
    }

	func setFavorite(_ favorited: Bool, atIndexPath: IndexPath) {
		var object = posts[atIndexPath.row]
		object.favorite = favorited

		posts[atIndexPath.row] = object
		self.resultsTableController?.posts = self.posts

		if let cell = self.resultsTableController?.tableView.cellForRow(at: atIndexPath) as? PostCell {
			cell.configureSearchPost(object)
		}
	}

    // MARK: - Public methods -

    func showFavoritesAction() {
        showFavorites = !showFavorites
		var predicateArray = [categoryPredicate, isPodcastPredicate]
		fetchController?.filteringFavorite = showFavorites

        if showFavorites {
			predicateArray.append(favoritePredicate)
        }
		let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicateArray)
		fetchController?.fetchRequest.predicate = predicate

		fetchController?.reloadData()
		UIView.transition(with: tableView, duration: 0.4, options: showFavorites ? .transitionFlipFromRight : .transitionFlipFromLeft, animations: {
			self.tableView.reloadData()
		})
    }

    // MARK: - Local methods -

    fileprivate func hasData() -> Bool {
        return fetchController?.hasData() ?? false
    }

	fileprivate func getPodcasts(paged: Int) {
        showSpin?()
        API().getPodcasts(page: paged) { post in
            DispatchQueue.main.async {
                self.hideSpin?()

                guard let post = post else {
                    // When post == nil, indicates the last post retrieved
                    self.fetchController?.reloadData()
                    return
                }
                if !post.duration.isEmpty {
                    CoreDataStack.shared.save(post: post)
                }
            }
        }

	}

	func searchPodcasts(_ text: String) {
		let processResponse: (XMLPost?) -> Void = { post in
			guard let post = post else {
				DispatchQueue.main.async {
					self.posts.sort(by: {
						$0.pubDate.toDate().sortedDate().compare($1.pubDate.toDate().sortedDate()) == .orderedDescending
					})

					self.resultsTableController?.posts = self.posts
				}
				return
			}
			if !post.duration.isEmpty {
				self.posts.append(post)
				CoreDataStack.shared.save(post: post)
			}
		}
		posts = []
		API().searchPodcasts(text, processResponse)
	}

}
