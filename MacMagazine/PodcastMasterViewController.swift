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
		tableView.setContentOffset(.zero, animated: true)
	}

	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		direction = offset.y > lastContentOffset.y ? .down : .up
		lastContentOffset = offset
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

	// MARK: - Actions methods -

	@IBAction private func getPodcasts() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
			self.getPodcasts(paged: 0)
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
        return (fetchController?.hasData() ?? false) && !(self.refreshControl?.isRefreshing ?? true)
    }

	fileprivate func getPodcasts(paged: Int) {
		let getPodcast = {
			API().getPodcasts(page: paged) { post in
				DispatchQueue.main.async {
					guard let post = post else {
						// When post == nil, indicates the last post retrieved
						self.fetchController?.reloadData()
						if paged < 1 {
							self.refreshControl?.endRefreshing()
						}
						return
					}
					if !post.duration.isEmpty {
						CoreDataStack.shared.save(post: post)
					}
				}
			}
		}

		if paged < 1 {
			self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
			UIView.animate(withDuration: 0.4, animations: {
				self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.refreshControl?.frame.size.height ?? 88)), animated: false)
			}, completion: { _ in
				self.refreshControl?.beginRefreshing()
				getPodcast()
			})
		} else {
			getPodcast()
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
					self.resultsTableController?.isSearching = false
				}
				return
			}
			self.posts.append(post)
		}
		posts = []
		API().searchPodcasts(text, processResponse)
	}

}
