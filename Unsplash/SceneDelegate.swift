//
//  SceneDelegate.swift
//  Unsplash
//
//  Created by Tanya on 05.02.2023.
//

import UIKit
import SnapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let feedVC = FeedVC()
        let feedNavController = UINavigationController(rootViewController: feedVC)
        feedNavController.title = "Home"
        
        let favoritesVC = FavoritesVC()
        let favoritesNavController = UINavigationController(rootViewController: favoritesVC)
        favoritesNavController.title = "Favorites"
        
        let tabbar = UnsplashTabBarController()
        tabbar.setViewControllers([feedNavController, favoritesNavController], animated: true)
        
        guard let items = tabbar.tabBar.items else { return }
        let images = ["house", "star"]
        for i in 0...1 {
            items[i].image = UIImage(systemName: images[i])
        }
        tabbar.tabBar.tintColor = .label
        
        self.window = window
        window.rootViewController = tabbar
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
