//
//  PostsMasterViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 18/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import UIKit
import CoreData

class PostsMasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

	// MARK: - Properties -
	
	let managedObjectContext = DataController.sharedInstance.managedObjectContext
	var detailViewController: PostsDetailViewController? = nil

	lazy var lazyImage: LazyImage = LazyImage()

	// MARK: - View Lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 44

		self.getPosts()
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)

		if (self.refreshControl?.isRefreshing)! {
			self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.refreshControl?.frame.size.height)!), animated: true)
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
		        let object = Posts.getPost(atIndex: indexPath.row)
		        let controller = (segue.destination as! UINavigationController).topViewController as! PostsDetailViewController
		        controller.detailItem = object
		        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - Fetched Results Controller Methods -
	
	lazy var fetchedResultsController: NSFetchedResultsController<Posts> = {
		let fetchRequest: NSFetchRequest<Posts> = Posts.fetchRequest()
		
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]

		if self.tabBarController!.selectedIndex == 0 {
			fetchRequest.predicate = NSPredicate(format: "NOT categorias CONTAINS[cd] %@", String(Categoria.podcast.rawValue))
		} else if self.tabBarController!.selectedIndex == 1 {
			fetchRequest.predicate = NSPredicate(format: "categorias CONTAINS[cd] %@", String(Categoria.podcast.rawValue))
		}

		// Initialize Fetched Results Controller
		let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		
		controller.delegate = self
		
		do {
			try controller.performFetch()
		} catch {
			let fetchError = error as NSError
			print("\(fetchError), \(fetchError.userInfo)")
		}
		
		return controller
	}()
	
	// MARK: - Fetched Results Controller Delegate Methods -

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		
		switch (type) {
		case .insert:
			if let indexPath = newIndexPath {
				tableView.insertRows(at: [indexPath], with: .fade)
			}
			break;
		case .delete:
			if let indexPath = indexPath {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			break;
		case .update:
			if let indexPath = indexPath {
				if let cell = tableView.cellForRow(at: indexPath) as? postCell {
					configure(cell: cell, atIndexPath: indexPath)
				}
			}
			break;
		case .move:
			if let indexPath = indexPath {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			
			if let newIndexPath = newIndexPath {
				tableView.insertRows(at: [newIndexPath], with: .fade)
			}
			break;
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}

	// MARK: - Table View -

	override func numberOfSections(in tableView: UITableView) -> Int {
		if let sections = self.fetchedResultsController.sections {
			return sections.count
		}
		
		return 0
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = self.fetchedResultsController.sections {
			let sectionInfo = sections[section]
			return sectionInfo.numberOfObjects
		}
		
		return 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let object = fetchedResultsController.object(at: indexPath)

		let identifier = (object.categorias.contains(String(Categoria.destaque.rawValue)) ? "featuredCell" : "normalCell")
		guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? postCell else {
            fatalError("Unexpected Index Path")
        }

		let bgColorView = UIView()
		bgColorView.backgroundColor = UIColor(hex: "008aca", alpha: 0.3)
		cell.selectedBackgroundView = bgColorView

		configure(cell: cell, atIndexPath: indexPath)

        return cell
	}

	func configure(cell: postCell, atIndexPath: IndexPath) {
		let object = fetchedResultsController.object(at: atIndexPath)

		cell.headlineLabel!.text = object.title
		
		if object.categorias.contains(String(Categoria.destaque.rawValue)) == false {
			if (cell.subheadlineLabel) != nil {
				cell.subheadlineLabel!.text = object.excerpt
			}
		}
		
		if let url = object.artworkURL {
			self.loadImage(imageView: cell.thumbnailImageView, url: url, spin: cell.spin)
		} else {

			Network.getImageURL(host: Site.artworkURL.withParameter(nil), query: "\(object.artwork)") {
				(result: String?) in
				
				if result != nil {
					object.artworkURL = result!
					self.loadImage(imageView: cell.thumbnailImageView, url: (object.artworkURL)!, spin: cell.spin)
				}
			}
		}
	}
	
	// MARK: - View Methods -

	@IBAction func getPosts() {
		self.refreshControl?.beginRefreshing()
		
		let query = "\(Site.perPage.withParameter(20))&\(Site.page.withParameter(1))"
		Network.getPosts(host: Site.posts.withParameter(nil), query: query) {
			() in
			
			DispatchQueue.main.async {
				self.refreshControl?.endRefreshing()
				// Execute the fetch to display the data
				do {
					try self.fetchedResultsController.performFetch()
				} catch {
					print("An error occurred")
				}
			}
		}
	}

	func loadImage(imageView: UIImageView, url: String, spin: UIActivityIndicatorView) {
		DispatchQueue.main.async {
			imageView.alpha = 0

			spin.startAnimating()
			self.lazyImage.showWithSpinner(imageView: imageView, url: url) {
				(error:LazyImageError?) in

				//Image loaded. Do something..
				spin.stopAnimating()
				imageView.alpha = 1
			}
		}
	}
}

