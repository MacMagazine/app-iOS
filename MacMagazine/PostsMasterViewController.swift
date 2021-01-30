//
//  PostsMasterViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 18/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import CoreData
import CoreSpotlight
import Kingfisher
import SafariServices
import UIKit
import WidgetKit

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

// MARK: -

enum Direction {
	case down
	case up
}

// MARK: -

class PostsMasterViewController: UITableViewController, FetchedResultsControllerDelegate, ResultsViewControllerDelegate {

	// MARK: - Properties -

    var fetchController: FetchedResultsControllerDataSource?
	var detailViewController: PostsDetailViewController?

	@IBOutlet private weak var logoView: UIView!
    @IBOutlet private weak var spin: UIActivityIndicatorView!
    @IBOutlet private weak var favorite: UIBarButtonItem!

	var lastContentOffset = CGPoint()
	var direction: Direction = .up
	var lastPage = -1

    var comeFrom3DTouch = false
	var viewDidAppear = false

	var selectedIndexPath: IndexPath?
	var links: [PostData] = []

	private var searchController: UISearchController?
	private var resultsTableController: ResultsViewController?
	var posts = [XMLPost]()

    let favoritePredicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))

    enum Status {
        case firstLoad
        case lastOpenedPost
        case recentPost
        case unknown
    }

    var status = Status.firstLoad

    // MARK: - View Lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(onRefreshAfterBackground(_:)), name: .refreshAfterBackground, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(onShortcutActionLastPost(_:)), name: .shortcutActionLastPost, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(onShortcutActionRecentPost(_:)), name: .shortcutActionRecentPost, object: nil)

		if Settings().isPad {
			NotificationCenter.default.addObserver(self, selector: #selector(onUpdateSelectedPost(_:)), name: .updateSelectedPost, object: nil)
		}

        NotificationCenter.default.addObserver(self, selector: #selector(onReloadData(_:)), name: .reloadData, object: nil)

		navigationItem.titleView = logoView
		navigationItem.title = nil

		fetchController = FetchedResultsControllerDataSource(post: self.tableView, group: "headerDate")
        fetchController?.delegate = self
        fetchController?.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "headerDate", ascending: false),
                                                         NSSortDescriptor(key: "pubDate", ascending: false)]

		resultsTableController = ResultsViewController()
		resultsTableController?.delegate = self
		resultsTableController?.isPodcast = false

		searchController = UISearchController(searchResultsController: resultsTableController)
		searchController?.searchBar.autocapitalizationType = .none
		searchController?.searchBar.delegate = self
		searchController?.searchBar.placeholder = "Buscar nos posts..."
		searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.searchBar.returnKeyType = .search

        self.extendedLayoutIncludesOpaqueBars = true

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 133

        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 36

        // Execute the fetch to display the data
        fetchController?.reloadData()

        favorite.accessibilityLabel = "Listar posts favoritos."
    }

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = Settings().isPad

        super.viewWillAppear(animated)

        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        delegate.supportedInterfaceOrientation = Settings().orientations

        if Settings().isPhone {
			selectedIndexPath = nil
		}

        if !hasData() {
			lastPage = -1
            status = .firstLoad
        } else {
            status = .lastOpenedPost
        }
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		processSelection()
		viewDidAppear = true

        if Settings().whatsNew != Settings().appVersion {
            self.performSegue(withIdentifier: "showWhatsNewSegue", sender: self)
        }
	}

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { _ in
            Settings().updateCookies(based: newCollection)
        }
    }

	// MARK: - Segues -

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
            let controller = navController.topViewController as? PostsDetailViewController,
            let indexPath = selectedIndexPath
            else {
                return
        }

        guard let _ = navigationItem.searchController else {
            // Normal Posts table
            if tableView.indexPathForSelectedRow != nil {
                guard let post = fetchController?.object(at: indexPath) else {
                    return
                }
                prepareDetailController(controller, using: links, compare: post.link)
            }
            return
        }
        // Search Posts table
        if resultsTableController?.tableView.indexPathForSelectedRow != nil {
            prepareDetailController(controller, using: links, compare: posts[indexPath.row].link)
        }
    }

	// MARK: - View Methods -

	func willDisplayCell(indexPath: IndexPath) {
		if direction == .down {
			let page = Int(tableView.rowNumber(indexPath: indexPath) / 19) + 1
			if page >= lastPage && tableView.rowNumber(indexPath: indexPath) % 19 == 0 {
				lastPage = page
				self.getPosts(paged: page)
			}
		}
	}

	func configure(cell: PostCell, atIndexPath: IndexPath) {
		guard let object = fetchController?.object(at: atIndexPath) else {
			return
		}
		cell.configurePost(object)
	}

	func didSelectRowAt(indexPath: IndexPath) {
		if selectedIndexPath != indexPath {
			links = fetchController?.links() ?? []
			selectedIndexPath = indexPath
			self.performSegue(withIdentifier: "showDetail", sender: self)

			guard let object = fetchController?.object(at: indexPath),
				let link = object.link else {
					return
			}
			updateLastSelectedPost(link: link)
		}
		if Settings().isPhone {
			self.tableView.deselectRow(at: indexPath, animated: true)
		}
	}

	func configureResult(cell: PostCell, atIndexPath: IndexPath) {
		if !posts.isEmpty {
			let object = posts[atIndexPath.row]
			cell.configureSearchPost(object)
		}
	}

	func didSelectResultRowAt(indexPath: IndexPath) {
		selectedIndexPath = indexPath
		self.links = posts.map { PostData(title: $0.title, link: $0.link, thumbnail: $0.artworkURL, favorito: $0.favorite, postId: $0.postId, shortURL: $0.shortURL) }
		self.performSegue(withIdentifier: "showDetail", sender: self)
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

    // MARK: - Local methods -

    fileprivate func hasData() -> Bool {
        return (fetchController?.hasData() ?? false) && !spin.isAnimating
    }

	fileprivate func getPosts(paged: Int) {
        var images: [String] = []
        var searchableItems: [CSSearchableItem] = []

        showSpin()

        API().getPosts(page: paged) { post in
            DispatchQueue.main.async {
                guard let post = post else {
                    // Prefetch images to be able to sent to Apple Watch
                    let urls = images.compactMap { URL(string: $0) }
                    let prefetcher = ImagePrefetcher(urls: urls)
                    prefetcher.start()

                    // Index all items to Spotlight
                    CSSearchableIndex.default().indexSearchableItems(searchableItems) {
                        if let error = $0 {
                            logE(error.localizedDescription)
                        }
                    }

                    // When post == nil, indicates the last post retrieved
                    self.hideSpin()

                    // Reload Widgets
                    if #available(iOS 14.0, *) {
                        WidgetCenter.shared.reloadAllTimelines()
                    }

                    if paged < 1 {
                        if self.status == .recentPost {
                            // Came from 3D touch
                            let indexPath = IndexPath(row: 0, section: 0)
                            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)

                            if Settings().isPad {
                                self.fetchController?.tableView(self.tableView, didSelectRowAt: indexPath)
                            } else {
                                self.didSelectRowAt(indexPath: indexPath)
                            }
                            self.status = .unknown
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                self.processSelection()
                            }
                        }
                    }
                    return
                }
                images.append(post.artworkURL)
                searchableItems.append(self.createSearchableItem(post))

                CoreDataStack.shared.save(post: post)
            }
        }
	}

	fileprivate func createSearchableItem(_ post: XMLPost) -> CSSearchableItem {
		let attributeSet = CSSearchableItemAttributeSet(itemContentType: "kUTTypeData")
		attributeSet.title = post.title
		attributeSet.contentDescription = post.excerpt
		if let url = URL(string: post.artworkURL) {
			attributeSet.thumbnailURL = url
		}
		return CSSearchableItem(uniqueIdentifier: post.link, domainIdentifier: "MMPosts", attributeSet: attributeSet)
	}

	fileprivate func processSelection() {
        if status == .firstLoad {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.lastPage = 0
                self.getPosts(paged: 0)
			}
		}
        if status == .firstLoad ||
            status == .lastOpenedPost {
            processTabletSelection()
        }
        if Settings().isPhone {
            self.status = .unknown
        }
	}

	fileprivate func getLastSelection(_ completion: @escaping (IndexPath) -> Void) {
        if status == .recentPost {
			completion(IndexPath(row: 0, section: 0))
		}

		guard let selectedPostLink = UserDefaults.standard.object(forKey: "selectedPostLink") as? [String: AnyObject],
			let link = selectedPostLink["link"] as? String,
			let date = selectedPostLink["date"] as? Date
			else {
				completion(IndexPath(row: 0, section: 0))
				return
		}
		// Check for 12h selection
		if date.addingTimeInterval(12 * 60 * 60) > Date() ||
			comeFrom3DTouch {
			comeFrom3DTouch = false
			CoreDataStack.shared.get(link: link) { posts in
				completion(self.fetchController?.indexPath(for: posts[0]) ?? IndexPath(row: 0, section: 0))
			}
		} else {
			completion(IndexPath(row: 0, section: 0))
		}
	}

	fileprivate func processTabletSelection() {
        if Settings().isPad &&
            tableView.numberOfSections > 0 {

			getLastSelection { indexPath in
				if self.tableView.numberOfSections >= indexPath.section && self.tableView.numberOfRows(inSection: indexPath.section) >= indexPath.row {
					if self.hasData() {
						self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
						self.fetchController?.tableView(self.tableView, didSelectRowAt: indexPath)
                        self.status = .unknown
					}
				}
			}
        }
	}

	fileprivate func processPhoneSelection() {
		if Settings().isPhone &&
			tableView.numberOfSections > 0 {

			getLastSelection { indexPath in
				if self.tableView.numberOfSections >= indexPath.section && self.tableView.numberOfRows(inSection: indexPath.section) >= indexPath.row && self.hasData() {
					self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
					self.didSelectRowAt(indexPath: indexPath)
				}
			}
		}
	}

}

// MARK: - Scroll detection -

extension PostsMasterViewController {
	override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if navigationItem.titleView == spin &&
            direction == .up {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
				self.getPosts(paged: 0)
			}
		}
	}

	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        direction = offset.y > lastContentOffset.y ? .down : .up
        lastContentOffset = offset

        // Pull to Refresh
        if offset.y < -150 &&
            navigationItem.titleView == logoView &&
            navigationItem.searchController == nil &&
			fetchController?.fetchRequest.predicate == nil {
			showSpin()
        }
    }
}

// MARK: - Spin -

extension PostsMasterViewController {
    func showSpin() {
		DispatchQueue.main.async {
        	self.navigationItem.titleView = self.spin
        	self.spin.startAnimating()
		}
    }

    func hideSpin() {
		DispatchQueue.main.async {
        	self.spin.stopAnimating()
        	self.navigationItem.titleView = self.logoView
		}
    }
}

// MARK: - UISearchBarDelegate -

extension PostsMasterViewController: UISearchBarDelegate {
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		resultsTableController?.showTyping()
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text else {
			return
		}
		fetchController?.fetchRequest.predicate = nil
		resultsTableController?.posts = []
		resultsTableController?.showSpin()
		searchPosts(text)
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		posts = []
		resultsTableController?.posts = posts
		searchBar.resignFirstResponder()
        navigationItem.searchController = nil
    }
}

// MARK: - Notifications -

extension PostsMasterViewController {
    @objc func onRefreshAfterBackground(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getPosts(paged: 0)
        }
    }

	@objc func onUpdateSelectedPost(_ notification: Notification) {
		guard let link = notification.object as? String else {
			return
		}
		CoreDataStack.shared.get(link: link) { (posts: [Post]) in
			let indexPath = self.fetchController?.indexPath(for: posts[0]) ?? IndexPath(row: 0, section: 0)
			self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)

			// Validate selection
			self.updateLastSelectedPost(link: link)
		}
	}

	fileprivate func updateLastSelectedPost(link: String) {
		// Validate selection
		guard let selectedPostLink = UserDefaults.standard.object(forKey: "selectedPostLink") as? [String: AnyObject],
			let previouslink = selectedPostLink["link"] as? String
			else {
				let selectedPostLink: [String: AnyObject] = ["link": link as AnyObject, "date": Date() as AnyObject]
				UserDefaults.standard.set(selectedPostLink, forKey: "selectedPostLink")
				UserDefaults.standard.synchronize()

				return
		}

		if previouslink != link {
			let selectedPostLink: [String: AnyObject] = ["link": link as AnyObject, "date": Date() as AnyObject]
			UserDefaults.standard.set(selectedPostLink, forKey: "selectedPostLink")
			UserDefaults.standard.synchronize()
		}
	}

    @objc func onReloadData(_ notification: Notification) {
        self.tableView.reloadData()
    }
}

// MARK: - Peek&Pop -

extension PostsMasterViewController {

	fileprivate func processOption(openRecentPost: Bool) {
		comeFrom3DTouch = true
        status = openRecentPost ? .recentPost : .lastOpenedPost

        if status == .lastOpenedPost ||
			viewDidAppear {
			if Settings().isPad {
				processTabletSelection()
			} else {
				processPhoneSelection()
			}
		}
	}

	@objc func onShortcutActionLastPost(_ notification: Notification) {
		processOption(openRecentPost: false)
	}

	@objc func onShortcutActionRecentPost(_ notification: Notification) {
		processOption(openRecentPost: true)
	}

}

// MARK: - Common Methods -

func prepareDetailController(_ controller: PostsDetailViewController, using links: [PostData], compare link: String?) {
	controller.navigationItem.leftItemsSupplementBackButton = true

	controller.selectedIndex = links.firstIndex(where: { $0.link == link }) ?? 0
	controller.links = links
	controller.createWebViewController = createWebViewController
}

func createWebViewController(post: PostData) -> WebViewController? {
	let storyboard = UIStoryboard(name: "WebView", bundle: nil)
	guard let controller = storyboard.instantiateViewController(withIdentifier: "PostDetail") as? WebViewController else {
		return nil
	}
	controller.post = post
	return controller
}

func showDetailController(with link: String) {
	let storyboard = UIStoryboard(name: "Main", bundle: nil)
	guard let controller = storyboard.instantiateViewController(withIdentifier: "detailController") as? PostsDetailViewController else {
		return
	}
	CoreDataStack.shared.links { links in
		prepareDetailController(controller, using: links, compare: link)

		guard let tabController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UITabBarController else {
			return
		}
		// Force first tab to present losing of reference
		tabController.selectedIndex = 0
		if let splitVC = tabController.selectedViewController as? UISplitViewController,
			let navVC = splitVC.children[Settings().isPhone ? 0 : 1] as? UINavigationController {

			if Settings().isPhone {
				splitVC.showDetailViewController(controller, sender: nil)
			} else {
				// Need to add the controller to navigation to see the nav bar
				navVC.viewControllers = [controller]
				splitVC.showDetailViewController(navVC, sender: nil)
			}
		}
	}
}

// MARK: - Easter Egg -

extension PostsMasterViewController {
    @IBAction private func easterEgg(_ sender: Any) {
        let api = API().getMMURL()
        let urls = ["\(api)sobre/",
                    "\(api)usados-apple/",
                    "\(api)equipe/",
                    "\(api)patroes/",
                    "\(api)tour/"
        ]
        guard let url = URL(string: urls[Int.random(in: 0..<urls.count)]) else {
            return
        }
        openInSafari(url)
    }

    func openInSafari(_ url: URL) {
        if url.scheme?.lowercased().contains("http") ?? false {
            let safari = SFSafariViewController(url: url)
            safari.setup()
            self.present(safari, animated: true, completion: nil)
        }
    }
}

// MARK: - Favorite Action methods -

extension PostsMasterViewController {
    @IBAction private func showHideFavorites(_ sender: Any) {
        if fetchController?.fetchRequest.predicate == nil {
            favorite.image = UIImage(systemName: "star.fill")
            favorite.accessibilityLabel = "Listar posts."
            showFavorites()
        } else {
            favorite.image = UIImage(systemName: "star")
            favorite.accessibilityLabel = "Listar posts favoritos."
            hideFavorites()
        }
    }

    fileprivate func showFavorites() {
        fetchController?.fetchRequest.predicate = favoritePredicate

        self.navigationItem.titleView = nil
        self.navigationItem.title = "Favoritos"

        reloadController(.transitionFlipFromRight)
    }

    fileprivate func hideFavorites() {
        fetchController?.fetchRequest.predicate = nil

        self.navigationItem.titleView = logoView
        self.navigationItem.title = nil

        reloadController(.transitionFlipFromLeft)
    }

    fileprivate func reloadController(_ direction: UIView.AnimationOptions) {
        fetchController?.reloadData()
        UIView.transition(with: tableView,
                          duration: 0.4,
                          options: direction,
                          animations: {
            self.tableView.reloadData()
        })
    }
}

// MARK: - Search Action methods -

extension PostsMasterViewController {
    @IBAction private func search(_ sender: Any) {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        resultsTableController?.showTyping()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.searchController?.searchBar.becomeFirstResponder()
        }
    }

	fileprivate func searchPosts(_ text: String) {
		var items: [CSSearchableItem] = []
		posts = []
        API().searchPosts(text) { post in
            guard let post = post else {
                self.posts.removeDuplicates()
                self.posts.sort(by: {
                    $0.pubDate.toDate().sortedDate().compare($1.pubDate.toDate().sortedDate()) == .orderedDescending
                })

                DispatchQueue.main.async {
                    CSSearchableIndex.default().indexSearchableItems(items)
                    self.resultsTableController?.posts = self.posts
                }
                return
            }
            self.posts.append(post)
            CoreDataStack.shared.save(post: post)
            items.append(self.createSearchableItem(post))
        }
	}

	fileprivate func searchPosts(category: String) {
        showSpin()

		var items: [CSSearchableItem] = []
		let processResponse: (XMLPost?) -> Void = { post in
			guard let post = post else {
				DispatchQueue.main.async {
                    self.hideSpin()

					CSSearchableIndex.default().indexSearchableItems(items)

					self.fetchController?.fetchRequest.predicate = NSPredicate(format: "categorias contains[cd] %@", category)
					self.reloadController(.transitionFlipFromRight)
				}
				return
			}
			CoreDataStack.shared.save(post: post)
			items.append(self.createSearchableItem(post))
		}

		if navigationItem.searchController == nil {
		}

		API().searchPosts(category: category, processResponse)
	}
}
