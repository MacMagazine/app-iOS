//
//  ResultsViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 10/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

protocol ResultsViewControllerDelegate: AnyObject {
	func didSelectResultRowAt(indexPath: IndexPath)
	func configureResult(cell: PostCell, atIndexPath: IndexPath)
	func setFavorite(_ favorited: Bool, atIndexPath: IndexPath)
}

extension ResultsViewControllerDelegate {
	func didSelectResultRowAt(indexPath: IndexPath) {}
}

class ResultsViewController: UITableViewController {

	// MARK: - Properties -

	weak var delegate: ResultsViewControllerDelegate?

	var isPodcast: Bool = false {
		didSet {
			tableView.register(UINib(nibName: isPodcast ? "PodcastCell" : "FeaturedCell", bundle: nil), forCellReuseIdentifier: "featuredCell")
		}
	}
	var posts: [XMLPost] = [] {
		didSet {
			if posts.isEmpty {
				showNotFound()
			} else {
				showResults()
			}
		}
	}

	// MARK: - View lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "normalCell")
		tableView.register(UINib(nibName: isPodcast ? "PodcastCell" : "FeaturedCell", bundle: nil), forCellReuseIdentifier: "featuredCell")

		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 133
	}

	// MARK: - TableView methods -

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}

	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let favoritar = UIContextualAction(style: .normal, title: nil) { _, _, boolValue in
			var object = self.posts[indexPath.row]
			Favorite().updatePostStatus(using: object.link) { isFavoriteOn in
				object.favorite = isFavoriteOn
				NotificationCenter.default.post(name: .favoriteUpdated, object: object)
				self.delegate?.setFavorite(isFavoriteOn, atIndexPath: indexPath)
				boolValue(true)
			}
		}

		let object = self.posts[indexPath.row]
		favoritar.image = UIImage(named: "fav_cell\(object.favorite ? "" : "_off")")
		favoritar.backgroundColor = UIColor(hex: "0097d4", alpha: 1)
		favoritar.accessibilityLabel = "Favoritar"

		let swipeActions = UISwipeActionsConfiguration(actions: [favoritar])
		swipeActions.performsFirstActionWithFullSwipe = true
		return swipeActions
	}

	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let compatilhar = UIContextualAction(style: .normal, title: nil) { _, _, boolValue in

			let post = self.posts[indexPath.row]
			let link = post.link
			guard let url = URL(string: link) else {
				boolValue(true)
				return
			}

			let cell = self.tableView.cellForRow(at: indexPath)
			let items: [Any] = [post.title, url]
			Share().present(at: cell, using: items)

			boolValue(true)
		}
		compatilhar.backgroundColor = UIColor(hex: "0097d4", alpha: 1)
		compatilhar.image = UIImage(named: "share")
		compatilhar.accessibilityLabel = "Compartilhar"

		let swipeActions = UISwipeActionsConfiguration(actions: [compatilhar])
		swipeActions.performsFirstActionWithFullSwipe = true
		return swipeActions
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var identifier = "normalCell"
		if posts[indexPath.row].categories.contains("Destaques") {
			identifier = "featuredCell"
		}

		guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PostCell else {
			fatalError("Unexpected Index Path")
		}
		delegate?.configureResult(cell: cell, atIndexPath: indexPath)
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.didSelectResultRowAt(indexPath: indexPath)
	}

	// MARK: - View methods -

	func showSpin() {
		let spin = UIActivityIndicatorView(style: .whiteLarge)
		spin.startAnimating()
		tableView.backgroundView = spin
		tableView.separatorStyle = .none

		tableView.reloadData()
	}

	func showResults() {
		tableView.backgroundView = nil
		tableView.separatorStyle = posts.count > 1 ? .singleLine : .none
		tableView.reloadData()
	}

	func showTyping() {
		showMessage("Digite as palavras-chave e\ndepois toque em \"Buscar\"")
	}

	func showNotFound() {
		showMessage("Nenhum resultado encontrado")
	}

	func showMessage(_ message: String) {
		let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
		messageLabel.text = message
		messageLabel.textColor = Settings().isDarkMode() ? .white : .black
		messageLabel.textAlignment = .center
		messageLabel.numberOfLines = 0

		tableView.backgroundView = messageLabel
		tableView.separatorStyle = .none

		tableView.reloadData()
	}

}
