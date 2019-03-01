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

class PostsMasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

	// MARK: - Properties -

	let managedObjectContext = DataController.sharedInstance.managedObjectContext
	var detailViewController: PostsDetailViewController?

	var nextPage = 0

	// MARK: - View Lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 133

		self.getPosts(paged: 0)
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
		super.viewWillAppear(animated)

		UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).with {
			$0.textAlignment = .center
		}

		if self.refreshControl?.isRefreshing ?? true {
			self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.refreshControl?.frame.size.height ?? 88)), animated: true)
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
                guard let navController = segue.destination as? UINavigationController else {
                    return
                }
                guard let controller = navController.topViewController as? PostsDetailViewController else {
                    return
                }
		        controller.detailItem = fetchedResultsController.object(at: indexPath)
		        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - Fetched Results Controller Methods -

	lazy var fetchedResultsController: NSFetchedResultsController<Posts> = {
		let fetchRequest: NSFetchRequest<Posts> = Posts.fetchRequest()

		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "headerDate", ascending: false),
										NSSortDescriptor(key: "pubDate", ascending: false)]
		fetchRequest.predicate = NSPredicate(format: "NOT categorias CONTAINS[cd] %@", "Podcast")

		// Initialize Fetched Results Controller
		let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "headerDate", cacheName: nil)
		controller.delegate = self

		do {
			try controller.performFetch()
		} catch {
			let fetchError = error as NSError
			print("\(fetchError), \(fetchError.userInfo)")
		}

		return controller
	}()

	// MARK: - Table View -

	override func numberOfSections(in tableView: UITableView) -> Int {
		if let sections = self.fetchedResultsController.sections {
			return sections.count
		}
		return 0
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let sections = fetchedResultsController.sections {
			let currentSection = sections[section]
			return currentSection.name.toHeaderDate()
		}
		return nil
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

        var identifier = "normalCell"
        if object.categorias.contains("Destaques") {
            identifier = "featuredCell"
        }

		guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PostCell else {
			fatalError("Unexpected Index Path")
		}
		configure(cell: cell, atIndexPath: indexPath)
		return cell
	}

	func configure(cell: PostCell, atIndexPath: IndexPath) {
		let object = fetchedResultsController.object(at: atIndexPath)
        cell.configurePost(object)
	}

	// MARK: - View Methods -

	@IBAction private func getPosts(paged: Int) {

		self.refreshControl?.beginRefreshing()

        let processResponse: (XMLPost?) -> Void = { post in
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }

            guard let post = post else {
                return
            }
            Posts.insertOrUpdatePost(post: post)
            DataController.sharedInstance.saveContext()

			self.nextPage = paged + 1

			DispatchQueue.main.async {
                // Execute the fetch to display the data
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    print("An error occurred")
                }
            }
        }

		API().getPosts(page: paged, processResponse)
	}

}
