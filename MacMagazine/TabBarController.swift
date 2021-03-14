import UIKit

class TabBarController: NSObject, UITabBarControllerDelegate {

    static let shared = TabBarController()

    var previousController: UIViewController?
    var controllers: [UIViewController]?

    override init() {
        guard let tabController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UITabBarController else {
            return
        }
        controllers = tabController.viewControllers
    }

    // MARK: - Indexes -

    func selectIndex(_ index: Int) {
        guard let tabController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UITabBarController else {
            return
        }
        if index < tabController.viewControllers?.count ?? 0 {
            tabController.selectedIndex = index
        }
    }

    func removeIndexes(_ indexex: [Int]) {
        guard let tabController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UITabBarController else {
            return
        }
        var controllers = self.controllers
        indexex.sorted(by: { $0 > $1 }).forEach { index in
            if index < controllers?.count ?? 0 {
                controllers?.remove(at: index)
                tabController.viewControllers = controllers
            }
        }
    }

    func resetTabs() {
        guard let tabController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UITabBarController else {
            return
        }
        tabController.viewControllers = self.controllers
    }

    // MARK: - Delegate -

    // Tap 2x to Top
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navVC = viewController as? UINavigationController,
           let vc = navVC.children[0] as? UITableViewController {
            if previousController == vc {
                vc.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
                vc.tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: false)
            }
            previousController = vc
        } else if let navVC = viewController as? UINavigationController,
                  let vc = navVC.children[0] as? PodcastViewController {
            if previousController == vc {
                NotificationCenter.default.post(name: .scrollToTop, object: nil)
            }
            previousController = vc
        } else if let splitVC = viewController as? UISplitViewController,
                  let navVC = splitVC.children[0] as? UINavigationController,
                  let vc = navVC.children[0] as? PostsMasterViewController {
            if previousController == vc || previousController == nil {
                if navVC.children.count > 1,
                   let navDetail = navVC.children[1] as? UINavigationController,
                   let detail = navDetail.children[0] as? PostsDetailViewController,
                   navVC.visibleViewController == detail {
                    navVC.popViewController(animated: true)
                } else {
                    if vc.tableView.numberOfSections > 0 &&
                        vc.tableView.numberOfRows(inSection: 0) > 0 {
                        vc.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
                        vc.tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: false)
                    }
                }
            }
            previousController = vc
        } else if let navVC = viewController as? UINavigationController,
                  let vc = navVC.children[0] as? VideoCollectionViewController {
            if previousController == vc {
                vc.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
            }
            previousController = vc
        }
    }
}
