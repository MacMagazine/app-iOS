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
	func setFavorite(_ favorited: Bool, atIndexPath: IndexPath) {}
}

class ResultsViewController: UITableViewController {

	// MARK: - Properties -

	weak var delegate: ResultsViewControllerDelegate?

	var isPodcast: Bool = false {
		didSet {
			tableView.register(UINib(nibName: "PodcastCell", bundle: nil), forCellReuseIdentifier: "podcastCell")
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
        tableView.register(UINib(nibName: "FeaturedCell", bundle: nil), forCellReuseIdentifier: "featuredCell")

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

        let object = self.posts[indexPath.row]

		let favoritar = UIContextualAction(style: .normal, title: "Favorito") { _, _, boolValue in
			var object = self.posts[indexPath.row]
			Favorite().updatePostStatus(using: object.link) { isFavoriteOn in
				object.favorite = isFavoriteOn
				NotificationCenter.default.post(name: .favoriteUpdated, object: object)
				self.delegate?.setFavorite(isFavoriteOn, atIndexPath: indexPath)
				boolValue(true)
			}
		}

		favoritar.image = UIImage(systemName: "star\(object.favorite ? "" : ".fill")")
        favoritar.backgroundColor = UIColor(named: "MMBlue") ?? .systemBlue
		favoritar.accessibilityLabel = "Favorito"

		let swipeActions = UISwipeActionsConfiguration(actions: [favoritar])
		swipeActions.performsFirstActionWithFullSwipe = true
		return swipeActions
	}

	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let compatilhar = UIContextualAction(style: .normal, title: "Compartilhar") { _, _, boolValue in

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
        compatilhar.backgroundColor = UIColor.systemGreen
		compatilhar.image = UIImage(systemName: "square.and.arrow.up")
		compatilhar.accessibilityLabel = "Compartilhar"

		let swipeActions = UISwipeActionsConfiguration(actions: [compatilhar])
		swipeActions.performsFirstActionWithFullSwipe = true
		return swipeActions
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contentSize: UIContentSizeCategory = UIApplication.shared.preferredContentSizeCategory

        var identifier = "normalCell"
        if posts[indexPath.row].categories.contains("Destaques") ||
            contentSize > .extraExtraExtraLarge {
			identifier = "featuredCell"
		}
        if !posts[indexPath.row].podcastURL.isEmpty {
            identifier = "podcastCell"
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
		let spin = UIActivityIndicatorView(style: .large)
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
		tableView.backgroundView = Settings().createLabel(message: message, size: tableView.bounds.size)
		tableView.separatorStyle = .none

		tableView.reloadData()
	}

}
