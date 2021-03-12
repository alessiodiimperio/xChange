//
//  RootAssembly.swift
//  xChange
//
//  Created by Alessio on 2021-03-08.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class RootAssembly: Assembly {
    
    func assemble(container: Container) {
        assembleRootTabBar(container)
    }
        
    private func assembleRootTabBar(_ container: Container){
        assembleViewModels(container)
        assembleViewControllers(container)
    }
    
    private func assembleViewModels(_ container: Container){
        container.register(LoginViewModel.self){r in
            return LoginViewModel()
        }
        container.register(SignUpViewModel.self){r in
            return SignUpViewModel()
        }
    }
    
    private func assembleViewControllers(_ container: Container){
        let rootStoryboard = SwinjectStoryboard.create(name: "Root", bundle: Bundle.main, container: container)

        container.register(LoginViewController.self) { r in
            let controller = rootStoryboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
            controller.viewModel = r.resolve(LoginViewModel.self)
            return controller
        }
        
        container.register(SignUpViewController.self) { r in
            let controller = rootStoryboard.instantiateViewController(identifier: String(describing: SignUpViewController.self)) as! SignUpViewController
            controller.viewModel = r.resolve(SignUpViewModel.self)
            return controller
        }
        
        container.register(TabBarController.self) { r in
            let mainCoordinator = r.resolve(MainCoordinator.self)!
            let favoritesCoordinator = r.resolve(FavoritesCoordinator.self)!
            let addXChangeCoordinator = r.resolve(AddXChangeCoordinator.self)!
            let chatCoordinator = r.resolve(ChatCoordinator.self)!
            let profileCoordinator = r.resolve(ProfileCoordinator.self)!
            
            let tabBar = rootStoryboard.instantiateViewController(withIdentifier: String(describing: TabBarController.self)) as! TabBarController
            
            tabBar.mainCoordinator = mainCoordinator
            tabBar.favoritesCoordinator = favoritesCoordinator
            tabBar.addXChangeCoordinator = addXChangeCoordinator
            tabBar.chatCoordinator = chatCoordinator
            tabBar.profileCoordinator = profileCoordinator
            
            return tabBar
        }
    }
}
