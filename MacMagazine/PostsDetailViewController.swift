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

	var selectedIndex = 0
	var links: [PostData] = []
	var createWebViewController: ((PostData) -> UIViewController?)?

	private(set) lazy var orderedViewControllers: [UIViewController] = {
		return links.map { post in
			return self.createWebViewController?(post) ?? UIViewController()
		}
	}()

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
