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
	var isLoading = false

	// MARK: - View Lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		NotificationCenter.default.addObserver(self, selector: #selector(onScrollToTop(_:)), name: .scrollToTop, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onReloadData(_:)), name: .reloadData, object: nil)

		fetchController = FetchedResultsControllerDataSource(podcast: self.tableView)
        fetchController?.delegate = self
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userActivity?.invalidate()
    }

    // MARK: - Scroll detection -

	override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if isLoading &&
            direction == .up {
			delay(0.4) {
				self.getPodcasts(paged: 0)
			}
		}
	}

	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		direction = offset.y > lastContentOffset.y ? .down : .up
		lastContentOffset = offset

        // Pull to Refresh
        if offset.y < -150 &&
            navigationItem.searchController == nil {
			showSpin?()
			isLoading = true
		}
	}

	// MARK: - View Methods -

	func showActionSheet(_ view: UIView?, for items: [Any]) {
		Share().present(at: view, using: items)
	}

	func willDisplayCell(indexPath: IndexPath) {
		if direction == .down {
			let page = Int(tableView.rowNumber(indexPath: indexPath) / 16) + 1
			if page >= lastPage &&
                tableView.rowNumber(indexPath: indexPath) % 16 == 0 {
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
        } else {
            selectedIndex = indexPath
        }
        guard let object = fetchController?.object(at: indexPath) else {
            return
        }
        let podcast = Podcast(title: object.title, duration: object.duration, url: object.podcastURL, frame: object.podcastFrame)
        play?(podcast)

        // Handoff
        guard let url = object.link else {
            return
        }
        let handoff = NSUserActivity(activityType: "com.brit.macmagazine.details")
        handoff.title = object.title
        handoff.webpageURL = URL(string: url)
        userActivity = handoff
        userActivity?.becomeCurrent()

        fetchController?.object(at: indexPath)?.read = true
        CoreDataStack.shared.save()
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
                guard let post = post else {
                    // When post == nil, indicates the last post retrieved
                    self.isLoading = false
                    self.hideSpin?()

                    return
                }
                if !post.duration.isEmpty {
                    CoreDataStack.shared.save(post: post)
                }
            }
        }

	}

	func searchPodcasts(_ text: String) {
		posts = []
        API().searchPodcasts(text) { post in
            guard let post = post else {
                self.posts.removeDuplicates()
                self.posts.sort(by: {
                    $0.pubDate.toDate().sortedDate().compare($1.pubDate.toDate().sortedDate()) == .orderedDescending
                })
                DispatchQueue.main.async {
                    self.resultsTableController?.posts = self.posts
                }
                return
            }
            if !post.duration.isEmpty {
                self.posts.append(post)
                CoreDataStack.shared.save(post: post)
            }
        }
	}

}

// MARK: - Notifications -

extension PodcastMasterViewController {
    @objc func onScrollToTop(_ notification: Notification) {
        if tableView.numberOfSections > 0 &&
            tableView.numberOfRows(inSection: 0) > 0 {
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
            tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: false)
        }
    }

    @objc func onReloadData(_ notification: Notification) {
        self.tableView.reloadData()
    }
}
