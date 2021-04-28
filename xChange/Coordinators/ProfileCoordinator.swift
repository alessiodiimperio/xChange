//
//  ProfileCoordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-26.
//

import UIKit
import Swinject
import SwinjectStoryboard
import RxSwift
import Firebase

class ProfileCoordinator:Coordinator {
    let container: Container
    
    weak var parentCoordinator:RootCoordinator?
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(navigationController:UINavigationController, container: Container){
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let delegate: ProfileViewControllerDelegate? = self
        let profileViewController = container.resolve(ProfileViewController.self, argument: delegate)!
        profileViewController.tabBarItem.image = UIImage(systemName: "person.fill")
        profileViewController.tabBarItem.title = "Profile"
        navigationController.pushViewController(profileViewController, animated: false)
    }
}

extension ProfileCoordinator: ProfileViewControllerDelegate {
    func didSelectSignOut() {
        parentCoordinator?.signOut()
    }
}
