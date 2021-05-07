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

protocol ProfileCoordinatorDelegate: AnyObject {
    func signOut()
}

class ProfileCoordinator:Coordinator {
    let container: Container
    
    weak var delegate: ProfileCoordinatorDelegate?
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(navigationController:UINavigationController, container: Container, delegate: ProfileCoordinatorDelegate?){
        self.navigationController = navigationController
        self.container = container
        self.delegate = delegate
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
        delegate?.signOut()
    }
    
    func didSelectGoToDetailView(for xChange: XChange) {
        let delegate: DetailViewControllerDelegate? = self
        let detailViewController = container.resolve(DetailViewController.self, arguments: xChange, delegate)!
        navigationController.pushViewController(detailViewController, animated: true)
    }
}

extension ProfileCoordinator: DetailViewControllerDelegate {
    func didSelectXchangeSold(in viewController: BaseViewController) {
        navigationController.popToRootViewController(animated: true)
    }
    
    func didSelectGoToDirectChat(with chatId: String) {
    }
}
