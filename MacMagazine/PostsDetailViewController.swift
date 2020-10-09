//
//  DetailViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 18/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import UIKit

class PostsDetailViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

	// MARK: - Properties -

    @IBOutlet private weak var fullscreenMode: UIBarButtonItem!
    @IBOutlet private weak var splitviewMode: UIBarButtonItem!

	var selectedIndex = 0
	var links: [PostData] = []
	var createWebViewController: ((PostData) -> UIViewController?)?

	private(set) lazy var orderedViewControllers: [UIViewController] = {
		return links.map { post in
			return self.createWebViewController?(post) ?? UIViewController()
		}
	}()

    var showFullscreenModeButton = true

	// MARK: - View lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		dataSource = self
		delegate = self

		var controller = UIViewController()
		if !orderedViewControllers.isEmpty {
			controller = orderedViewControllers[selectedIndex]
		}
		setViewControllers([controller], direction: .forward, animated: true, completion: nil)

        if Settings().isPad &&
            self.splitViewController != nil {
            navigationItem.leftBarButtonItem = fullscreenMode
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard !links.isEmpty,
            let link = links[selectedIndex].link else {
            return
        }
        updatePostHandoff(title: links[selectedIndex].title, link: link)
        updatePostReadStatus(link: link)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        userActivity?.invalidate()
    }

	// MARK: - PageViewController -

	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if !completed {
			return
		}
		guard let vc = pageViewController.viewControllers?.first as? WebViewController,
			let index = orderedViewControllers.firstIndex(of: vc),
			let link = links[index].link
			else {
				return
		}
		if Settings().isPad {
			NotificationCenter.default.post(name: .updateSelectedPost, object: link)
		}

        updatePostHandoff(title: links[index].title, link: link)
        updatePostReadStatus(link: link)
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

		guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
			return nil
		}

		let previousIndex = viewControllerIndex - 1

		guard previousIndex >= 0 else {
			return nil
		}

		guard orderedViewControllers.count > previousIndex else {
			return nil
		}

		return orderedViewControllers[previousIndex]

	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

		guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
			return nil
		}

		let nextIndex = viewControllerIndex + 1
		let orderedViewControllersCount = orderedViewControllers.count

		guard orderedViewControllersCount != nextIndex else {
			return nil
		}

		guard orderedViewControllersCount > nextIndex else {
			return nil
		}

		return orderedViewControllers[nextIndex]

	}

}

// MARK: - Read status -

extension PostsDetailViewController {
    func updatePostReadStatus(link: String) {
        CoreDataStack.shared.get(link: link) { (items: [Post]) in
            if !items.isEmpty {
                items[0].read = true
                CoreDataStack.shared.save()
            }
        }
    }
}

// MARK: - Handoff -

extension PostsDetailViewController {
    func updatePostHandoff(title: String?, link: String) {
        userActivity?.invalidate()

        let handoff = NSUserActivity(activityType: "com.brit.macmagazine.details")
        handoff.title = title
        handoff.webpageURL = URL(string: link)
        userActivity = handoff

        userActivity?.becomeCurrent()
    }
}

// MARK: - Fullscreen Mode -

extension PostsDetailViewController {
    @IBAction private func enterFullscreenMode(_ sender: Any?) {
        showFullscreenModeButton = false
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.splitViewController?.preferredDisplayMode = .primaryHidden
                       },
                       completion: { _ in
                        self.navigationItem.leftBarButtonItem = self.splitviewMode
                       })
    }

    func enterFullscreenMode() {
        self.enterFullscreenMode(fullscreenMode)
    }

    @IBAction private func enterSplitViewMode(_ sender: Any?) {
        showFullscreenModeButton = true
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.splitViewController?.preferredDisplayMode = .allVisible
                       },
                       completion: { _ in
                        self.navigationItem.leftBarButtonItem = self.fullscreenMode
                       })
    }

    func enterSplitViewMode() {
        self.enterSplitViewMode(splitviewMode)
    }
}
