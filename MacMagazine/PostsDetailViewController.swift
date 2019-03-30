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

	private(set) lazy var orderedViewControllers: [UIViewController] = {
		return links.map { post in
			if let vc = self.parent as? PostsMasterViewController {
				// Comes from table.didSelect
				return vc.createWebViewController(post: post) ?? UIViewController()
			} else if let vc = self.parent?.parent?.children[0] as? PostsMasterViewController {
				// Comes from Peek&Pop
				return vc.createWebViewController(post: post) ?? UIViewController()
			} else {
				return UIViewController()
			}
		}
	}()

	// MARK: - View lifecycle -

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		dataSource = self
		delegate = self

		setViewControllers([orderedViewControllers[selectedIndex]], direction: .forward, animated: true, completion: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - PageViewController -

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

	// MARK: - View methods -

	public func share(_ index: Int) {
		print(index)
	}
}
