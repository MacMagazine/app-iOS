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
	@IBOutlet private weak var favorite: UIBarButtonItem!

	var lastContentOffset = CGPoint()
	var direction: Direction = .up
	var lastPage = -1
	var openRecentPost = false
	var viewDidAppear = false

	var selectedIndexPath: IndexPath?
	var links: [PostData] = []

	private var searchController: UISearchController?
	private var resultsTableController: ResultsViewController?
	var posts = [XMLPost]()

	var showFavorites = false
    let categoryPredicate = NSPredicate(format: "NOT categorias CONTAINS[cd] %@", "Podcast")
    let favoritePredicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))

    // MARK: - View Lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		// Apply custom thmee (Dark/Light)
		applyTheme()

		NotificationCenter.default.addObserver(self, selector: #selector(onShortcutActionLastPost(_:)), name: .shortcutActionLastPost, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(onShortcutActionRecentPost(_:)), name: .shortcutActionRecentPost, object: nil)

		self.navigationItem.titleView = logoView
		self.navigationItem.title = nil

		fetchController = FetchedResultsControllerDataSource(withTable: self.tableView, group: "headerDate", featuredCellNib: "FeaturedCell")
        fetchController?.delegate = self
		fetchController?.filteringFavorite = false
        fetchController?.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "headerDate", ascending: false),
                                                         NSSortDescriptor(key: "pubDate", ascending: false)]

		resultsTableController = ResultsViewController()
		resultsTableController?.delegate = self
		resultsTableController?.isPodcast = false
		resultsTableController?.isSearching = false

		searchController = UISearchController(searchResultsController: resultsTableController)
		searchController?.searchBar.autocapitalizationType = .none
		searchController?.searchBar.delegate = self
		searchController?.searchBar.placeholder = "Buscar nos posts..."
		searchController?.hidesNavigationBarDuringPresentation = true
		self.definesPresentationContext = true

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 133

		if traitCollection.forceTouchCapability == .available {
			registerForPreviewing(with: self, sourceView: self.tableView)
		}

		// Execute the fetch to display the data
		fetchController?.reloadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = Settings().isPad()

        super.viewWillAppear(animated)

		if Settings().isPhone() {
			selectedIndexPath = nil
		}

        if !hasData() {
			lastPage = -1
        }
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		processSelection()
		viewDidAppear = true
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

	func showActionSheet(_ view: UIView?, for items: [Any]) {
		Share().present(at: view, using: items)
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

	func configure(cell: PostCell, atIndexPath: IndexPath) {
		guard let object = fetchController?.object(at: atIndexPath) else {
			return
		}
		cell.configurePost(object)
	}

	func didSelectRowAt(indexPath: IndexPath) {
		if selectedIndexPath != indexPath {
			self.links = fetchController?.links() ?? []
			selectedIndexPath = indexPath
			self.performSegue(withIdentifier: "showDetail", sender: self)

			guard let object = fetchController?.object(at: indexPath) else {
				return
			}
			UserDefaults.standard.set(object.link, forKey: "selectedPostLink")
			UserDefaults.standard.synchronize()
		}
		if Settings().isPhone() {
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
		self.links = posts.map { PostData(title: $0.title, link: $0.link, thumbnail: $0.artworkURL, favorito: false) }
		self.performSegue(withIdentifier: "showDetail", sender: self)
	}

	// MARK: - Actions methods -

	@IBAction private func search(_ sender: Any) {
		navigationItem.searchController = searchController
		searchController?.searchBar.becomeFirstResponder()
	}

	@IBAction private func getPosts(_ sender: Any) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
			self.getPosts(paged: 0)
		}
	}

	@IBAction private func showFavorites(_ sender: Any) {
		showFavorites = !showFavorites
        if showFavorites {
			fetchController?.fetchRequest.predicate = favoritePredicate
			fetchController?.filteringFavorite = true

			self.navigationItem.titleView = nil
			self.navigationItem.title = "Favoritos"
			favorite.image = UIImage(named: "fav_on")
        } else {
			fetchController?.fetchRequest.predicate = nil
			fetchController?.filteringFavorite = false

			self.navigationItem.titleView = logoView
			self.navigationItem.title = nil
			favorite.image = UIImage(named: "fav_off")
		}

		fetchController?.reloadData()
		UIView.transition(with: tableView, duration: 0.4, options: showFavorites ? .transitionFlipFromRight : .transitionFlipFromLeft, animations: {
			self.tableView.reloadData()
		})
	}

	// MARK: - Local methods -

    fileprivate func hasData() -> Bool {
        return (fetchController?.hasData() ?? false) && !(self.refreshControl?.isRefreshing ?? true)
    }

	fileprivate func getPosts(paged: Int) {
		let getPost = {
            var images: [String] = []
			var items: [CSSearchableItem] = []

			API().getPosts(page: paged) { post in
				DispatchQueue.main.async {
					guard let post = post else {
                        // Prefetch images to be able to sent to Apple Watch
                        let urls = images.compactMap { URL(string: $0) }
                        let prefetcher = ImagePrefetcher(urls: urls)
                        prefetcher.start()

						// Index all items to Spotlight
						CSSearchableIndex.default().indexSearchableItems(items) {
							if let error = $0 {
								logE(error.localizedDescription)
							}
						}

						// When post == nil, indicates the last post retrieved
						self.fetchController?.reloadData()

						if paged < 1 {
							if self.openRecentPost {
								// Came from 3D touch, openRecentPost
								let indexPath = IndexPath(row: 0, section: 0)
								self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)

								if Settings().isPad() {
									self.fetchController?.tableView(self.tableView, didSelectRowAt: indexPath)
								} else {
									self.didSelectRowAt(indexPath: indexPath)
								}

							} else {
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
									self.refreshControl?.endRefreshing()
									DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
										self.processSelection()
									}
								}
							}
							self.openRecentPost = false
						}
						return
					}
                    images.append(post.artworkURL)
					CoreDataStack.shared.save(post: post)

					items.append(self.createSearchableItem(post))
				}
			}
		}

		if paged < 1 {
			self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
			UIView.animate(withDuration: 0.4, animations: {
				self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.refreshControl?.frame.size.height ?? 88)), animated: false)
			}, completion: { _ in
				self.refreshControl?.beginRefreshing()
				getPost()
			})
		} else {
			getPost()
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
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
			if self.lastPage == -1 {
				self.lastPage = 0
				self.getPosts(0)
			}
		}
		processTabletSelection()
	}

	fileprivate func getLastSelection(_ completion: @escaping (IndexPath) -> Void) {
		if openRecentPost {
			completion(IndexPath(row: 0, section: 0))
		}

		guard let link = UserDefaults.standard.object(forKey: "selectedPostLink") as? String else {
			completion(IndexPath(row: 0, section: 0))
			return
		}
		CoreDataStack.shared.get(post: link) { posts in
			completion(self.fetchController?.indexPath(for: posts[0]) ?? IndexPath(row: 0, section: 0))
		}
	}

	fileprivate func processTabletSelection() {
        if Settings().isPad() &&
            tableView.numberOfSections > 0 {

			getLastSelection { indexPath in
				if self.tableView.numberOfSections >= indexPath.section && self.tableView.numberOfRows(inSection: indexPath.section) >= indexPath.row {
					if self.hasData() && !(self.refreshControl?.isRefreshing ?? false) {
						self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
						self.fetchController?.tableView(self.tableView, didSelectRowAt: indexPath)
					}
				}
			}
        }
	}

	fileprivate func processPhoneSelection() {
		if Settings().isPhone() &&
			tableView.numberOfSections > 0 {

			getLastSelection { indexPath in
				if self.tableView.numberOfSections >= indexPath.section && self.tableView.numberOfRows(inSection: indexPath.section) >= indexPath.row && self.hasData() {
					self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
					self.didSelectRowAt(indexPath: indexPath)
				}
			}
		}
	}

	fileprivate func searchPosts(_ text: String) {
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
		API().searchPosts(text, processResponse)
	}

}

// MARK: - UISearchBarDelegate -

extension PostsMasterViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text else {
			return
		}
		resultsTableController?.posts = []
		resultsTableController?.isSearching = true
		searchPosts(text)
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		posts = []
		searchBar.resignFirstResponder()
		navigationItem.searchController = nil
	}
}

// MARK: - UIViewControllerPreviewingDelegate -

extension PostsMasterViewController: UIViewControllerPreviewingDelegate, WebViewControllerDelegate {

	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

		guard let indexPath = tableView.indexPathForRow(at: location),
			let post = self.fetchController?.object(at: indexPath)
			else {
				return nil
		}
		tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
		selectedIndexPath = indexPath
		previewingContext.sourceRect = tableView.rectForRow(at: indexPath)

		guard let webController = createWebViewController(post: PostData(title: post.title, link: post.link, thumbnail: post.artworkURL, favorito: post.favorite)) as? WebViewController else {
			return nil
		}
		webController.delegate = self

		return webController
	}

	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		self.links = fetchController?.links() ?? []
		self.performSegue(withIdentifier: "showDetail", sender: self)
	}

	func previewActionFavorite(_ post: PostData?) {
		previewActionCancel()
		Favorite().updatePostStatus(using: post?.link ?? "")
	}

	func previewActionShare(_ post: PostData?) {
		previewActionCancel()

		guard let link = post?.link,
			let url = URL(string: link)
			else {
				return
		}

		let items: [Any] = [post?.title ?? "", url]
		showActionSheet(nil, for: items)
	}

	func previewActionCancel() {
		// Just in case, return the default theme colors
		let theme: Theme = Settings().isDarkMode() ? DarkTheme() : LightTheme()
		theme.apply(for: UIApplication.shared)

		guard let index = self.tableView.indexPathForSelectedRow else {
			return
		}
		self.tableView.deselectRow(at: index, animated: true)
	}

}

// MARK: - Peek&Pop -

extension PostsMasterViewController {

	fileprivate func processOption(openRecentPost: Bool, push: String?) {
		self.openRecentPost = openRecentPost

		if !openRecentPost ||
			viewDidAppear {
			if Settings().isPad() {
				processTabletSelection()
			} else {
				processPhoneSelection()
			}
		}
	}

	@objc func onShortcutActionLastPost(_ notification: Notification) {
		processOption(openRecentPost: false, push: nil)
	}

	@objc func onShortcutActionRecentPost(_ notification: Notification) {
		processOption(openRecentPost: true, push: nil)
	}

}

// MARK: - Common Methods -

func prepareDetailController(_ controller: PostsDetailViewController, using links: [PostData], compare link: String?) {
	controller.navigationItem.leftItemsSupplementBackButton = true
	controller.selectedIndex = links.firstIndex(where: { $0.link == link }) ?? 0
	controller.links = links
	controller.createWebViewController = createWebViewController
}

func createWebViewController(post: PostData) -> UIViewController? {
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

		guard let tabController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else {
			return
		}
		// Force first tab to present losing of reference
		tabController.selectedIndex = 0
		if let splitVC = tabController.selectedViewController as? UISplitViewController,
			let navVC = splitVC.children[Settings().isPhone() ? 0 : 1] as? UINavigationController {

			if Settings().isPhone() {
				splitVC.showDetailViewController(controller, sender: nil)
			} else {
				// Need to add the controller to navigation to see the nav bar
				navVC.viewControllers = [controller]
				splitVC.showDetailViewController(navVC, sender: nil)
			}
		}
	}
}

extension PostsMasterViewController {
	fileprivate func applyTheme() {
		guard let isDarkMode = UserDefaults.standard.object(forKey: "darkMode") as? Bool else {
			let theme: Theme = LightTheme()
			theme.apply(for: UIApplication.shared)
			return
		}
		let theme: Theme = isDarkMode ? DarkTheme() : LightTheme()
		theme.apply(for: UIApplication.shared)
	}
}
