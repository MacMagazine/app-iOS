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

// MARK: -

enum Direction {
	case down
	case up
}

struct PostData {
	var title: String?
	var link: String?
	var thumbnail: String?
	var favorito: Bool = false

	init(title: String?, link: String?, thumbnail: String?, favorito: Bool) {
		self.title = title
		self.link = link
		self.thumbnail = thumbnail
		self.favorito = favorito
	}
}

// MARK: -

class PostsMasterViewController: UITableViewController, FetchedResultsControllerDelegate, ResultsViewControllerDelegate {

	// MARK: - Properties -

    var fetchController: FetchedResultsControllerDataSource?
	var detailViewController: PostsDetailViewController?

	@IBOutlet private weak var logoView: UIView!

	var lastContentOffset = CGPoint()
	var direction: Direction = .up
	var lastPage = -1

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
		self.navigationItem.titleView = logoView
		self.navigationItem.title = nil

		fetchController = FetchedResultsControllerDataSource(withTable: self.tableView, group: "headerDate", featuredCellNib: "FeaturedCell")
        fetchController?.delegate = self
        fetchController?.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "headerDate", ascending: false),
                                                         NSSortDescriptor(key: "pubDate", ascending: false)]
//        fetchController?.fetchRequest.predicate = categoryPredicate

		resultsTableController = ResultsViewController()
		resultsTableController?.delegate = self
		resultsTableController?.isPodcast = false

		searchController = UISearchController(searchResultsController: resultsTableController)
		searchController?.searchBar.autocapitalizationType = .none
		searchController?.searchBar.delegate = self
		searchController?.searchBar.placeholder = "Buscar nos posts..."
		tableView.tableHeaderView = searchController?.searchBar

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

		UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).with {
			$0.textAlignment = .center
		}
		if Settings().isPhone() {
			selectedIndexPath = nil
		}

        if !hasData() {
			lastPage = -1
            getPosts(paged: 0)
        }
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if hasData() {
			processSelection()
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

	// MARK: - Segues -

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if tableView.indexPathForSelectedRow != nil {
			guard let navController = segue.destination as? UINavigationController,
				let controller = navController.topViewController as? PostsDetailViewController,
				let indexPath = selectedIndexPath,
				let post = fetchController?.object(at: indexPath)
				else {
					return
			}

			controller.navigationItem.leftItemsSupplementBackButton = true
			controller.selectedIndex = links.firstIndex(where: { $0.link == post.link }) ?? 0
			controller.links = links
			controller.createWebViewController = createWebViewController
		}
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
		if UIApplication.shared.canOpenURL(URL(string: "googlechrome://")!) {
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

			UserDefaults.standard.set(["row": indexPath.row, "section": indexPath.section], forKey: "selectedIndexPath")
			UserDefaults.standard.synchronize()
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

	@IBAction private func getPosts(_ sender: Any) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
			self.getPosts(paged: 0)
		}
	}

	@IBAction private func showFavorites(_ sender: Any) {
		showFavorites = !showFavorites
        if showFavorites {
//            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, favoritePredicate])
//            fetchController?.fetchRequest.predicate = predicate
			fetchController?.fetchRequest.predicate = favoritePredicate

			self.navigationItem.titleView = nil
			self.navigationItem.title = "Favoritos"
        } else {
//            fetchController?.fetchRequest.predicate = categoryPredicate
			fetchController?.fetchRequest.predicate = nil

			self.navigationItem.titleView = logoView
			self.navigationItem.title = nil
		}
		fetchController?.reloadData()
        tableView.reloadData()
	}

	// MARK: - Local methods -

    fileprivate func hasData() -> Bool {
        return (fetchController?.hasData() ?? false) && !(self.refreshControl?.isRefreshing ?? true)
    }

	fileprivate func getPosts(paged: Int) {
		if paged < 1 {
			self.refreshControl?.beginRefreshing()
			self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.refreshControl?.frame.size.height ?? 88)), animated: true)
		}

		API().getPosts(page: paged) { post in
			DispatchQueue.main.async {
				guard let post = post else {
					// When post == nil, indicates the last post retrieved
					self.fetchController?.reloadData()

					if paged < 1 {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
							self.refreshControl?.endRefreshing()
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
								self.tableView.setContentOffset(CGPoint(x: 0, y: 56), animated: true)
								self.processSelection()
							}
						}
					}
					return
				}
				CoreDataStack.shared.save(post: post)
			}
		}
	}

	fileprivate func processSelection() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
			if self.lastPage == -1 {
				self.lastPage = 0
				self.getPosts(0)
			}
		}

        if Settings().isPad() &&
            tableView.numberOfSections > 0 {

            guard let dict = UserDefaults.standard.object(forKey: "selectedIndexPath") as? [String: Int] else {
                tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
                fetchController?.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
                return
            }
            let indexPath = IndexPath(row: dict["row"] ?? 0, section: dict["section"] ?? 0)
			if tableView.numberOfSections >= indexPath.section && tableView.numberOfRows(inSection: indexPath.section) >= indexPath.row {
				if hasData() && !(self.refreshControl?.isRefreshing ?? false) {
					tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
					fetchController?.tableView(tableView, didSelectRowAt: indexPath)
				}
			}
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

		CoreDataStack.shared.get(post: post?.link ?? "") { items in
			if !items.isEmpty {
				items[0].favorite = !items[0].favorite
				CoreDataStack.shared.save()
			}
		}
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
		guard let index = self.tableView.indexPathForSelectedRow else {
			return
		}
		self.tableView.deselectRow(at: index, animated: true)
	}

}

// MARK: - Peek&Pop -

extension PostsMasterViewController {

	func createWebViewController(post: PostData) -> UIViewController? {
		let storyboard = UIStoryboard(name: "WebView", bundle: nil)
		guard let controller = storyboard.instantiateViewController(withIdentifier: "PostDetail") as? WebViewController else {
			return nil
		}
		controller.post = post

		return controller
	}

}
