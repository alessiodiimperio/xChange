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
        assembleViews(container)
        assembleViewModels(container)
        assembleViewControllers(container)
    }
    
    private func assembleViews(_ container: Container) {
        container.register(LoginView.self) { _ in
            LoginView()
        }
        
        container.register(SignUpView.self) { _ in
            SignUpView()
        }
    }
    
    private func assembleViewModels(_ container: Container){
        container.register(LoginViewModel.self){_ in
            LoginViewModel()
        }
        
        container.register(SignUpViewModel.self){_ in
            SignUpViewModel()
        }
    }
    
    private func assembleViewControllers(_ container: Container){

        container.register(LoginViewController.self) { (r, delegate: LoginViewControllerDelegate?) in
            
            let view = r.resolve(LoginView.self)!
            let viewModel = r.resolve(LoginViewModel.self)!
            
            return LoginViewController(view: view,
                                       viewModel: viewModel,
                                       delegate: delegate)
        
        }
        
        container.register(SignUpViewController.self) { (r, delegate: SignUpViewControllerDelegate?) in
            
            let view = r.resolve(SignUpView.self)!
            let viewModel = r.resolve(SignUpViewModel.self)!
            return SignUpViewController(view: view,
                                        viewModel: viewModel,
                                        delegate: delegate)
        }
        
        container.register(TabBarController.self) { (r,
                                                     delegate: TabBarControllerDelegate?,
                                                     mainCoordinator: MainCoordinator,
                                                     favouriteCoordinator: FavoritesCoordinator,
                                                     addXChangeCoordinator: AddXChangeCoordinator,
                                                     chatCoordinator: ChatCoordinator,
                                                     profileCoordinator: ProfileCoordinator) in
            
            return TabBarController(delegate: delegate,
                                    mainCoordinator: mainCoordinator,
                                    favouriteCoordinator: favouriteCoordinator,
                                    addXChangeCoordinator: addXChangeCoordinator,
                                    chatCoordinator: chatCoordinator,
                                    profileCoordinator: profileCoordinator)
        }
    }
}
