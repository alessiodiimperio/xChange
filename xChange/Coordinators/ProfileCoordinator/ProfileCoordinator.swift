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
    let container = SwinjectStoryboard.defaultContainer
    let disposeBag = DisposeBag()
    
    weak var parentCoordinator:RootCoordinator?
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        registerDependencies()
        let profileViewController = container.resolve(ProfileViewController.self)!
        profileViewController.coordinator = self
        profileViewController.tabBarItem.image = UIImage(systemName: "person.fill")
        profileViewController.tabBarItem.title = "Profile"
        navigationController.pushViewController(profileViewController, animated: false)
    }
}
//MARK: Dependency Registration
extension ProfileCoordinator {
    func registerDependencies(){
        let profileStoryboard = SwinjectStoryboard.create(name: "Profile", bundle: Bundle.main, container: container)
        container.register(ProfileViewModel.self){r in
            let dataProvider = r.resolve(DataProvider.self)!
            return ProfileViewModel(dataProvider: dataProvider)}
        
        container.register(ProfileViewController.self) { r in
            let controller = profileStoryboard.instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as! ProfileViewController
            controller.viewModel = r.resolve(ProfileViewModel.self)
            return controller
        }
    }
}

extension ProfileCoordinator: ProfileCoordinatorDelegate {
    func didSelectSignOut() {
        parentCoordinator?.signOut()
    }
}
