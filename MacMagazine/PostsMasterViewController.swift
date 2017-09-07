//
//  PostsMasterViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 18/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import UIKit

class PostsMasterViewController: UITableViewController {

	var detailViewController: PostsDetailViewController? = nil
	var posts = Posts()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)

		self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.refreshControl?.frame.size.height)!), animated: true)
		self.refreshControl?.beginRefreshing()
		let query = "\(Site.perPage.withParameter(20))&\(Site.page.withParameter(1))"
		Network.getPosts(host: Site.posts.withParameter(nil), query: query) {
			(result: Posts?) in
			
			if result != nil {
				self.posts = result!
				self.posts.excludePost(fromCategoryId: Categoria.podcast.rawValue)
			}
			DispatchQueue.main.async {
				self.tableView.reloadData()
				self.refreshControl?.endRefreshing()
			}
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = tableView.indexPathForSelectedRow {
		        let object = self.posts.getPostAtIndex(index: indexPath.row)
		        let controller = (segue.destination as! UINavigationController).topViewController as! PostsDetailViewController
		        controller.detailItem = object
		        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - Table View

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.posts.getNumberOfPosts()
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let object = self.posts.getPostAtIndex(index: indexPath.row)
		return ((object?.hasCategory(id: 674))! ? 212 : 151)
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let object = self.posts.getPostAtIndex(index: indexPath.row)

		let identifier = ((object?.hasCategory(id: Categoria.destaque.rawValue))! ? "featuredCell" : "normalCell")
		
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? postCell else {
            fatalError("Unexpected Index Path")
        }

		cell.headlineLabel!.text = object?.title
		
		if identifier == "normalCell" {
			cell.subheadlineLabel!.text = object?.excerpt
		}

		cell.thumbnailImageView.image = nil
		if let url = object?.artworkURL {
			self.loadImage(imageView: cell.thumbnailImageView, url: url, spin: cell.spin)
		} else {
			Network.getImageURL(host: Site.artworkURL.withParameter(nil), query: "\((object?.artwork)!)") {
				(result: String?) in
				
				if result != nil {
					object?.artworkURL = result!
					self.loadImage(imageView: cell.thumbnailImageView, url: (object?.artworkURL)!, spin: cell.spin)
				}
			}
		}

        return cell
	}

	// MARK: - View Methods

	func loadImage(imageView: UIImageView, url: String, spin: UIActivityIndicatorView) {
		DispatchQueue.main.async {
			spin.startAnimating()
			LazyImage.show(imageView: imageView, url: url, defaultImage:"image_logo") {
				() in
				//Image loaded. Do something..
				spin.stopAnimating()
			}
		}
	}
}

