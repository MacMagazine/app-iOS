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
	@IBOutlet private weak var favorite: UIBarButtonItem!
    @IBOutlet private weak var spin: UIActivityIndicatorView!

	var searchController: UISearchController?

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.titleView = logoView
		self.navigationItem.title = nil

		playerHeight.constant = 0.0

		guard let vc = self.children[0] as? PodcastMasterViewController else {
			return
		}
		vc.play = play
        vc.showSpin = showSpin
        vc.hideSpin = hideSpin

		vc.resultsTableController = ResultsViewController()
		vc.resultsTableController?.delegate = vc
		vc.resultsTableController?.isPodcast = true

		searchController = UISearchController(searchResultsController: vc.resultsTableController)
		searchController?.searchBar.autocapitalizationType = .none
		searchController?.searchBar.delegate = self
		searchController?.searchBar.placeholder = "Buscar nos podcasts..."
        searchController?.searchBar.returnKeyType = .search

        favorite.accessibilityLabel = "Listar podcasts favoritos."
    }

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)

		coordinator.animate(alongsideTransition: { _ in
			self.reloadData()
		}, completion: { _ in
			self.reloadData()
		})
	}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        delegate.supportedInterfaceOrientation = Settings().orientations
    }

    fileprivate func reloadData() {
		if self.tabBarController?.selectedIndex == 1 {
            guard let vc = self.children[0] as? PodcastMasterViewController else {
                return
            }
			vc.tableView.reloadData()
			vc.resultsTableController?.tableView.reloadData()
		}
	}

	// MARK: - Actions -

	@IBAction private func search(_ sender: Any) {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        delay(0.01) {
            self.searchController?.searchBar.becomeFirstResponder()
        }
	}

	@IBAction private func showFavorites(_ sender: Any) {
        guard let vc = self.children[0] as? PodcastMasterViewController else {
            return
        }
        vc.showFavoritesAction()

		if vc.showFavorites {
			self.navigationItem.titleView = nil
			self.navigationItem.title = "Favoritos"
			favorite.image = UIImage(systemName: "star.fill")
            favorite.accessibilityLabel = "Listar podcasts."
		} else {
			self.navigationItem.titleView = logoView
			self.navigationItem.title = nil
			favorite.image = UIImage(systemName: "star")
            favorite.accessibilityLabel = "Listar podcasts favoritos."
        }
    }

    // MARK: - Methods -

    fileprivate func showWebView(_ show: Bool) {
        playerHeight.constant = show ? 166.0 : 0.0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }

    fileprivate func play(_ podcast: Podcast?) {
        guard let vc = self.children[1] as? PlayerViewController else {
            return
        }
		vc.show = showWebView
        vc.podcast = podcast
    }

}

// MARK: - UISearchBarDelegate -

extension PodcastViewController: UISearchBarDelegate {
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		guard let vc = self.children[0] as? PodcastMasterViewController else {
			return
		}
		vc.resultsTableController?.showTyping()
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text,
			let vc = self.children[0] as? PodcastMasterViewController
			else {
				return
		}
		searchBar.resignFirstResponder()
		vc.resultsTableController?.posts = []
		vc.resultsTableController?.showSpin()
		vc.searchPodcasts(text)
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		navigationItem.searchController = nil
	}
}

// MARK: - Spin -

extension PodcastViewController {
    func showSpin() {
        navigationItem.titleView = spin
    }

    func hideSpin() {
        navigationItem.titleView = logoView
    }
}
