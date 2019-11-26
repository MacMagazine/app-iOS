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
    var categories = [String]()

    // MARK: - View Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Filtrar"
        tableView.backgroundColor = Settings().theme.backgroundColor

        CoreDataStack.shared.getCategories { [weak self] categories in
            self?.categories = categories.removingDuplicates().sorted()
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section > 1 ? "CATEGORIAS" : nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section > 1 ? categories.count : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filter", for: indexPath)

        // Configure the cell...
        if indexPath.section > 1 {
            cell.textLabel?.text = categories[indexPath.row]
        } else {
            cell.textLabel?.text = "Mostrar \(indexPath.section == 0 ? "Tudo" : "Favoritos")"
        }
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case 0:
            callback?(nil)
        case 1:
            callback?("")
        default:
            callback?(categories[indexPath.row])
        }
        self.navigationController?.popViewController(animated: true)
    }

}
