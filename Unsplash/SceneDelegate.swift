//
//  SceneDelegate.swift
//  Unsplash
//
//  Created by Tanya on 05.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let vc = FeedVC()
        let vc2 = FavoritesVC()
        let tabbar = UITabBarController()
        let navVC = UINavigationController(rootViewController: vc)
        let navVCTwo = UINavigationController(rootViewController: vc2)
        tabbar.setViewControllers([navVC, navVCTwo], animated: true)
        
        window.rootViewController = tabbar
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

}
