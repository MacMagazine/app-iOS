//
//  KeywordsTableViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 17/12/2021.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Combine
import UIKit

class KeywordsTableViewController: UITableViewController, ObservableObject {

    // MARK: - Properties -

    var keywords = [String]()
    var filter = [String]()
    @Published var selection = [String]()

    // MARK: - View Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        CoreDataStack.shared.getCategories { [weak self] categories in
            self?.keywords = categories
            self?.filter = categories
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Table view data source -

extension KeywordsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filter.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keyword", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = filter[indexPath.row]

        return cell
    }
}

// MARK: - Table view delegate -

extension KeywordsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection.append(filter[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selection = selection.filter { $0 != filter[indexPath.row] }
    }
}

// MARK: - Actions -

extension KeywordsTableViewController {
    @IBAction private func close(_ sender: Any) {
        self.dismiss(animated: true, completion: { self.selection = [] })
    }

    @IBAction private func search(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate -

extension KeywordsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter = keywords.filter { $0.contains(searchText) }

        if searchText.isEmpty {
            filter = keywords
        }

        tableView.reloadData()
    }
}
