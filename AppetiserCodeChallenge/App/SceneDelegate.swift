//
//  SceneDelegate.swift
//  AppetiserCodeChallenge
//
//  Created by Zahoor Gorsi on 03/03/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Load MovieList.storyboard, dont use name .storboard
        let storyboard = UIStoryboard(name: "MovieList", bundle: nil)
        // Instantiate MovieListViewController
        let movieListVC = storyboard.instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
        
        // Embed MovieListViewController in a UINavigationController
        let navigationController = UINavigationController(rootViewController: movieListVC)
        
        // Set the navigation controller as the root view controller of the window
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save the current date and time
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: "AppClosedDate")
    }
    
}
