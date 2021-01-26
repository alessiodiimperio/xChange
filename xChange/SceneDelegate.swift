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
    let container = Container()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}


