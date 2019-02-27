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

	// MARK: - View Lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 133

		self.getPosts()
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
		super.viewWillAppear(animated)

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

		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]

		if self.tabBarController?.selectedIndex == 0 {
			fetchRequest.predicate = NSPredicate(format: "NOT categorias CONTAINS[cd] %@", "Podcast")
		} else if self.tabBarController?.selectedIndex == 1 {
			fetchRequest.predicate = NSPredicate(format: "categorias CONTAINS[cd] %@", "Podcast")
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

		switch type {
		case .insert:
			if let indexPath = newIndexPath {
				tableView.insertRows(at: [indexPath], with: .fade)
			}
		case .delete:
			if let indexPath = indexPath {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
		case .update:
			if let indexPath = indexPath {
				if let cell = tableView.cellForRow(at: indexPath) as? PostCell {
					configure(cell: cell, atIndexPath: indexPath)
				}
			}
		case .move:
			if let indexPath = indexPath {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}

			if let newIndexPath = newIndexPath {
				tableView.insertRows(at: [newIndexPath], with: .fade)
			}
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

        var identifier = "normalCell"
        if self.tabBarController?.selectedIndex == 0 && object.categorias.contains("Destaques") {
            identifier = "featuredCell"
        }

		guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PostCell else {
            fatalError("Unexpected Index Path")
        }

		let bgColorView = UIView()
		bgColorView.backgroundColor = UIColor(hex: "008aca", alpha: 0.3)
		cell.selectedBackgroundView = bgColorView

		configure(cell: cell, atIndexPath: indexPath)

        return cell
	}

	func configure(cell: PostCell, atIndexPath: IndexPath) {
		let object = fetchedResultsController.object(at: atIndexPath)

        if self.tabBarController?.selectedIndex == 0 {
            cell.configurePost(object)
        }
        if self.tabBarController?.selectedIndex == 1 {
            cell.configurePodcast(object)
        }
	}

	// MARK: - View Methods -

	@IBAction private func getPosts() {

		self.refreshControl?.beginRefreshing()

        //let pages = (Posts.getNumberOfPosts() / 15) + 1
        let processResponse: (XMLPost?) -> Void = { post in
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }

            guard let post = post else {
                return
            }
            Posts.insertOrUpdatePost(post: post)
            DataController.sharedInstance.saveContext()

            DispatchQueue.main.async {
                // Execute the fetch to display the data
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    print("An error occurred")
                }
            }
        }

        if self.tabBarController?.selectedIndex == 0 {
            API().getPosts(page: 0, processResponse)
        }
        if self.tabBarController?.selectedIndex == 1 {
            API().getPodcasts(page: 0, processResponse)
        }
	}

}
