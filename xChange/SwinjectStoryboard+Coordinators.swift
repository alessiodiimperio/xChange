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

        //MARK: Coordinator Dependencies
        defaultContainer.register(MainCoordinator.self){ _ in
            let navigationController = UINavigationController()
            return MainCoordinator(navigationController: navigationController)
        }
        defaultContainer.register(FavoritesCoordinator.self){ _ in
            let navigationController = UINavigationController()
            return FavoritesCoordinator(navigationController: navigationController)
        }
        defaultContainer.register(AddXChangeCoordinator.self){ _ in
            let navigationController = UINavigationController()
            return AddXChangeCoordinator(navigationController: navigationController)
        }
        defaultContainer.register(ChatCoordinator.self){ _ in
            let navigationController = UINavigationController()
            return ChatCoordinator(navigationController: navigationController)
        }
        defaultContainer.register(ProfileCoordinator.self){ _ in
            let navigationController = UINavigationController()
            return ProfileCoordinator(navigationController: navigationController)
        }
        
        //MARK: Root.storyboard Dependencies
        //ViewModels
        defaultContainer.register(LoginViewModel.self){_ in
            return LoginViewModel()
        }
        //ViewControllers
        defaultContainer.storyboardInitCompleted(LoginViewController.self){ r, vc in
            vc.viewModel = r.resolve(LoginViewModel.self)
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
