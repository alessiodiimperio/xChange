//
//  SceneDelegate.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import UIKit
import Swinject
import SwinjectStoryboard

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator:RootCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let navigationController = RootNavigationController()
        coordinator = RootCoordinator(navigationController: navigationController)
        coordinator?.start()
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


