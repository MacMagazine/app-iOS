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
    var selectedPodcast = -1

	private var searchController: UISearchController?
	private var resultsTableController: ResultsViewController?
	var posts = [XMLPost]()

    var showFavorites = false
    let categoryPredicate = NSPredicate(format: "categorias CONTAINS[cd] %@", "Podcast")
    let favoritePredicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))

    var showWebView: ((Bool) -> Void)?
    var play: ((Podcast?) -> Void)?

	// MARK: - View Lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		NotificationCenter.default.addObserver(self, selector: #selector(onScrollToTop(_:)), name: NSNotification.Name(rawValue: "scrollToTop"), object: nil)

		fetchController = FetchedResultsControllerDataSource(withTable: self.tableView, group: nil, featuredCellNib: "PodcastCell")
        fetchController?.delegate = self
        fetchController?.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]
        fetchController?.fetchRequest.predicate = categoryPredicate

		resultsTableController = ResultsViewController()
		resultsTableController?.delegate = self
		resultsTableController?.isPodcast = true
		resultsTableController?.isSearching = false

		searchController = UISearchController(searchResultsController: resultsTableController)
		searchController?.searchBar.autocapitalizationType = .none
		searchController?.searchBar.delegate = self
		searchController?.searchBar.placeholder = "Buscar nos podcasts..."
		tableView.tableHeaderView = searchController?.searchBar

		self.definesPresentationContext = true

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 133

		// Execute the fetch to display the data
		fetchController?.reloadData()
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
		let safari = UIActivityExtensions(title: "Abrir no Safari", image: UIImage(named: "safari")) { items in
			for item in items {
				guard let url = URL(string: "\(item)") else {
					continue
				}
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}
		}

		let chrome = UIActivityExtensions(title: "Abrir no Chrome", image: UIImage(named: "chrome")) { items in
			for item in items {
				guard let url = URL(string: "\(item)".replacingOccurrences(of: "http", with: "googlechrome")) else {
					continue
				}
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}
		}
		var activities = [safari]
		if let url = URL(string: "googlechrome://"),
			UIApplication.shared.canOpenURL(url) {
			activities.append(chrome)
		}

		let activityVC = UIActivityViewController(activityItems: items, applicationActivities: activities)
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

    func didSelectRowAt(indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if selectedPodcast != indexPath.row {
            selectedPodcast = indexPath.row

            guard let object = fetchController?.object(at: indexPath) else {
                return
            }
            let podcast = Podcast(title: object.title, duration: object.duration, url: object.podcastURL)
            showWebView?(true)
            play?(podcast)
        } else {
            selectedPodcast = -1
            showWebView?(false)
        }
    }

    func configureResult(cell: PostCell, atIndexPath: IndexPath) {
        if !posts.isEmpty {
            let object = posts[atIndexPath.row]
            cell.configureSearchPodcast(object)
        }
    }

    func didSelectResultRowAt(indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if selectedPodcast != indexPath.row {
            selectedPodcast = indexPath.row

            let object = posts[selectedPodcast]
            let podcast = Podcast(title: object.title, duration: object.duration, url: object.podcastURL)
            showWebView?(true)
            play?(podcast)
        } else {
            selectedPodcast = -1
            showWebView?(false)
        }
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
		let getPodcast = {
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

// MARK: - UISearchBarDelegate -

extension PodcastMasterViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text else {
			return
		}
		searchBar.resignFirstResponder()
		resultsTableController?.posts = []
		resultsTableController?.isSearching = true
		searchPodcasts(text)
	}
}
