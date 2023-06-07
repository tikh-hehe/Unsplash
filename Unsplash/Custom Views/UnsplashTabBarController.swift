//
//  UnsplashTabBarController.swift
//  Unsplash
//
//  Created by tikh on 09.05.2023.
//

import UIKit

// Custom UITabBarController with scrolling feature on UITabBar tap

final class UnsplashTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let viewControllers else { return true }
        guard viewController == viewControllers[selectedIndex] else { return true }
        guard let navController = viewController as? UINavigationController else { return true }
        guard let topController = navController.viewControllers.last else { return true }
        
        if topController.isScrolledToTop {
            navController.popViewController(animated: true)
            return true
        } else {
            topController.scrollToTop()
            return false
        }
    }
}

extension UIViewController {
    func scrollToTop() {
        func scrollToTop(view: UIView?) {
            guard let view = view else { return }
            
            switch view {
            case let collectionView as UICollectionView:
                if collectionView.scrollsToTop {
                    collectionView.scrollToItem(at: IndexPath(row: -1, section: 0), at: .top, animated: true)
                    return
                }
            case let tableView as UITableView:
                if tableView.scrollsToTop {
                    if tableView.numberOfRows(inSection: 0) == 0 { return }
                    tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    return
                }
            default:
                break
            }
            
            for subView in view.subviews {
                scrollToTop(view: subView)
            }
        }
        
        scrollToTop(view: view)
    }
    
    var isScrolledToTop: Bool {
        for subview in view.subviews {
            switch subview {
                
            case let collectionView as UICollectionView:
                return (collectionView.contentOffset.y == 0)
                
            case let tableView as UITableView:
                return (tableView.contentOffset.y == 0)
                
            default:
                break
            }
        }
        return true
    }
}
