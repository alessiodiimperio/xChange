//
//  RootCoordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import UIKit
import Swinject
import SwinjectStoryboard

class RootCoordinator:Coordinator {
    let container = SwinjectStoryboard.defaultContainer
    var navigationController: UINavigationController
    var childrenCoordinators: [Coordinator] = [Coordinator]()
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    func start() {
        let loginViewController = LoginViewController.instatiate(from: "Root")
        loginViewController.coordinator = self
        navigationController.setViewControllers([loginViewController], animated: false)
    }
    func goToSignUp(){
        let signUpViewController = SignUpViewController.instatiate(from: "Root")
        signUpViewController.coordinator = self
        navigationController.present(signUpViewController, animated: true)
    }
    func signIn(){
        let tabBarController = TabBarController.instatiate(from: "Root")
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    func signOut(){
        navigationController.popToRootViewController(animated: true)
    }
}
