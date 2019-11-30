//
//  FilterTableViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 26/11/19.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

    // MARK: - Properties -

    var callback: ((String?) -> Void)?
    var categories = [Category]()
    @IBOutlet private weak var spin: UIActivityIndicatorView!

    // MARK: - View Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Filtrar"
        tableView.backgroundColor = Settings().theme.backgroundColor

		self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: spin)]
		self.spin.startAnimating()

		API().getCategories { [weak self] categories in
            guard let categories = categories else {
                return
            }
            self?.categories = categories

			DispatchQueue.main.async {
				self?.navigationItem.rightBarButtonItems = nil
				self?.tableView.reloadData()
			}
		}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return section > 0 ? "CATEGORIAS/TAGS" : nil
    }

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? 1 : categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filter", for: indexPath)

        // Configure the cell...
		if indexPath.section == 0 {
			cell.textLabel?.text = "Mostrar todos os posts"
		} else {
			cell.textLabel?.text = categories[indexPath.row].title
		}

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

		callback?(indexPath.section == 0 ? nil : categories[indexPath.row].title)

        self.navigationController?.popViewController(animated: true)
    }

}
