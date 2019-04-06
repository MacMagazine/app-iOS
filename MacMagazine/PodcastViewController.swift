//
//  PodcastViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController {

	// MARK: - Properties -

	@IBOutlet private weak var logoView: UIView!
    @IBOutlet private weak var playerHeight: NSLayoutConstraint!

	var searchController: UISearchController?

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		self.navigationItem.titleView = logoView
		self.navigationItem.title = nil

		guard let vc = self.children[0] as? PodcastMasterViewController else {
			return
		}
		vc.showWebView = showWebView
		vc.play = play

		vc.resultsTableController = ResultsViewController()
		vc.resultsTableController?.delegate = vc
		vc.resultsTableController?.isPodcast = true
		vc.resultsTableController?.isSearching = false

		searchController = UISearchController(searchResultsController: vc.resultsTableController)
		searchController?.searchBar.autocapitalizationType = .none
		searchController?.searchBar.delegate = self
		searchController?.searchBar.placeholder = "Buscar nos podcasts..."
		self.definesPresentationContext = true
    }

    // MARK: - Actions -

	@IBAction private func search(_ sender: Any) {
		navigationItem.searchController = searchController
		searchController?.searchBar.becomeFirstResponder()
	}

	@IBAction private func showFavorites(_ sender: Any) {
        guard let vc = self.children[0] as? PodcastMasterViewController else {
            return
        }
        vc.showFavoritesAction()

		if vc.showFavorites {
			self.navigationItem.titleView = nil
			self.navigationItem.title = "Favoritos"
		} else {
			self.navigationItem.titleView = logoView
			self.navigationItem.title = nil
		}
    }

    // MARK: - Methods -

    fileprivate func showWebView(_ show: Bool) {
        playerHeight.constant = show ? 200.0 : 0.0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        if !show {
            play(nil)
        }
    }

    fileprivate func play(_ podcast: Podcast?) {
        guard let vc = self.children[1] as? PlayerViewController else {
            return
        }
        vc.podcast = podcast
    }

}

// MARK: - UISearchBarDelegate -

extension PodcastViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text,
			let vc = self.children[0] as? PodcastMasterViewController
			else {
				return
		}
		searchBar.resignFirstResponder()
		vc.resultsTableController?.posts = []
		vc.resultsTableController?.isSearching = true
		vc.searchPodcasts(text)
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		navigationItem.searchController = nil
	}
}
