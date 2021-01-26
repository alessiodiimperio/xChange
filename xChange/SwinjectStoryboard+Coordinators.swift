//
//  SwinjectStoryboard.extensions.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import UIKit
import SwinjectStoryboard
extension SwinjectStoryboard {
    @objc class func setup() {
        
        defaultContainer.register(MainCoordinator.self){ _ in
            let navigationController = UINavigationController()
            return MainCoordinator(container: defaultContainer, navigationController: navigationController)
        }
        
        defaultContainer.register(FavoritesCoordinator.self){ _ in
            let navigationController = UINavigationController()
            return FavoritesCoordinator(container: defaultContainer, navigationController: navigationController)
        }
        
        defaultContainer.register(AddXChangeCoordinator.self){ _ in
            let navigationController = UINavigationController()
            return AddXChangeCoordinator(container: defaultContainer, navigationController: navigationController)
        }
        defaultContainer.register(ChatCoordinator.self){ _ in
            let navigationController = UINavigationController()
            return ChatCoordinator(container: defaultContainer, navigationController: navigationController)
        }
        defaultContainer.register(ProfileCoordinator.self){ _ in
            let navigationController = UINavigationController()
            return ProfileCoordinator(container: defaultContainer, navigationController: navigationController)
        }
        
        defaultContainer.storyboardInitCompleted(TabBarController.self) { r, vc in
            let mainCoordinator = r.resolve(MainCoordinator.self)!
            vc.mainCoordinator = mainCoordinator

            let favoritesCoordinator = r.resolve(FavoritesCoordinator.self)!
            vc.favoritesCoordinator = favoritesCoordinator

            let addXChangeCoordinator = r.resolve(AddXChangeCoordinator.self)!
            vc.addXChangeCoordinator = addXChangeCoordinator

            let chatCoordinator = r.resolve(ChatCoordinator.self)!
            vc.chatCoordinator = chatCoordinator

            let profileCoordinator = r.resolve(ProfileCoordinator.self)!
            vc.profileCoordinator = profileCoordinator
        }
    }
}
