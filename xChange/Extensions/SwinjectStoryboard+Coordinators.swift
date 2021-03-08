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
        
        //MARK: Services Dependencies
        defaultContainer.register(AuthenticationProvider.self){_ in
            return FirebaseAuthProvider()
        }.inObjectScope(.container)
        
        defaultContainer.register(DataProvider.self){r in
            let auth = r.resolve(AuthenticationProvider.self)
            return FirestoreDataProvider(auth: auth!)
        }.inObjectScope(.container)
        
        defaultContainer.register(FavoritesProvider.self) {r in
            let auth = r.resolve(AuthenticationProvider.self)!
            return FirebaseFavouriteProvider(auth: auth)
        }
        
        //MARK: Root.storyboard Dependencies
        //ViewModels
        defaultContainer.register(LoginViewModel.self){r in
            return LoginViewModel()
        }
        defaultContainer.register(SignUpViewModel.self){r in
            return SignUpViewModel()
        }
        //ViewControllers
        defaultContainer.storyboardInitCompleted(LoginViewController.self){ r, vc in
            vc.viewModel = r.resolve(LoginViewModel.self)
        }
        defaultContainer.storyboardInitCompleted(SignUpViewController.self){ r, vc in
            vc.viewModel = r.resolve(SignUpViewModel.self)
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
