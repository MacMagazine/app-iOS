//
//  CategoriesTableViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 26/11/19.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {

    // MARK: - Properties -

    @IBOutlet private weak var spin: UIActivityIndicatorView!
	@IBOutlet private weak var logoView: UIView!

	var callback: ((String) -> Void)?

	let searchController = UISearchController(searchResultsController: nil)

    var categories = [Category]()
	var filteredCategories = [Category]()

	var isSearchBarEmpty: Bool {
		return searchController.searchBar.text?.isEmpty ?? true
	}
	var isFiltering: Bool {
		return searchController.isActive && !isSearchBarEmpty
	}

    // MARK: - View Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.titleView = logoView
		navigationItem.title = nil

		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Buscar nas categorias..."
		navigationItem.searchController = searchController
		definesPresentationContext = true

		getCategories()
    }

	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        delegate.supportedInterfaceOrientation = Settings().orientations
	}

    // MARK: - Table view data source -

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
		return "Lista de Categorias"
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return isFiltering ? filteredCategories.count : categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categories", for: indexPath)

        // Configure the cell...
		cell.textLabel?.text = isFiltering ? filteredCategories[indexPath.row].title : categories[indexPath.row].title

        return cell
    }

    // MARK: - Table view delegate -

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

		let category = isFiltering ? filteredCategories[indexPath.row].title : categories[indexPath.row].title
		callback?(category)
		navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view delegate -

	func getCategories() {
		self.navigationItem.titleView = self.spin
		self.spin.startAnimating()

		API().getCategories { [weak self] categories in
			guard let categories = categories else {
				return
			}
			self?.categories = categories

			DispatchQueue.main.async {
				self?.navigationItem.titleView = self?.logoView
				self?.tableView.reloadData()
			}
		}
	}

}

// MARK: - Search -

extension CategoriesTableViewController: UISearchResultsUpdating {

	func filterContentForSearchText(_ searchText: String) {
		filteredCategories = categories.filter { category in
			return category.title.lowercased().contains(searchText.lowercased())
		}
		tableView.reloadData()
	}

	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		guard let text = searchBar.text else {
			return
		}
		filterContentForSearchText(text)
	}

}
