//
//  ProfileCoordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-26.
//

import UIKit
import Swinject
import SwinjectStoryboard

class ProfileCoordinator:Coordinator {
    
    let container = SwinjectStoryboard.defaultContainer
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        registerDependencies()
        let vc = container.resolve(ProfileViewController.self)!
        vc.coordinator = self
        vc.tabBarItem.image = UIImage(systemName: "person.fill")
        vc.tabBarItem.title = "Profile"
        navigationController.pushViewController(vc, animated: false)
    }
    func signOut(){
        print("Trying to sign out")
    }
    
    func registerDependencies(){
        let profileStoryboard = SwinjectStoryboard.create(name: "Profile", bundle: Bundle.main, container: container)
        container.register(ProfileViewModel.self){_ in return ProfileViewModel()}
        container.register(ProfileViewController.self) { r in
            let controller = profileStoryboard.instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as! ProfileViewController
            controller.viewModel = r.resolve(ProfileViewModel.self)
            return controller
        }
    }
}
