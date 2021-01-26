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
    
    weak var container:Container?
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(container:Container, navigationController:UINavigationController){
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        registerDependencies()
        let vc = container!.resolve(ProfileViewController.self)!
        vc.tabBarItem.image = UIImage(systemName: "person.fill")
        vc.tabBarItem.title = "Profile"
        navigationController.pushViewController(vc, animated: false)
    }
    
    func registerDependencies(){
        let profileStoryboard = SwinjectStoryboard.create(name: "Profile", bundle: Bundle.main, container: container!)
        container!.register(ProfileViewModel.self){_ in return ProfileViewModel()}
        container!.register(ProfileViewController.self) { r in
            let controller = profileStoryboard.instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as! ProfileViewController
            controller.viewModel = r.resolve(ProfileViewModel.self)
            return controller
        }
    }
}
