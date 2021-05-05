//
//  RootCoordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import UIKit
import RxSwift
import RxCocoa
import Swinject
import SwinjectStoryboard

class RootCoordinator: Coordinator {
    let container: Container
    var navigationController:UINavigationController
    var childrenCoordinators:[Coordinator] = [Coordinator]()
    let authenticator:AuthenticationProvider?
    var tabBarController: TabBarController?
    
    init(navigationController:UINavigationController, container: Container){
        self.navigationController = navigationController
        self.container = container
        self.authenticator = container.resolve(AuthenticationProvider.self)
    }
    
    func start() {
        navigationController.navigationBar.isHidden = true
        guard let auth = authenticator else { fatalError() }
        auth.isSignedIn() ? goToTabBarController() : goToLoginScreen()
    }
    
    func goToLoginScreen(){
        let delegate: LoginViewControllerDelegate? = self
        let loginViewController = container.resolve(LoginViewController.self, argument: delegate)!
        navigationController.setViewControllers([loginViewController], animated: false)
    }
    
    func goToSignUp(){
        let delegate: SignUpViewControllerDelegate? = self
        let signUpViewController = container.resolve(SignUpViewController.self, argument: delegate)!
        navigationController.present(signUpViewController, animated: true)
    }
    
    func goToTabBarController(){
        
        let tabBarDelegate: TabBarControllerDelegate? = self
        let mainCoordinatorDelegate: MainCoordinatorDelegate? = self
        let favoriteCoordinatorDelegate: FavoriteCoordinatorDelegate? = self
        let addXchangeCoordinatorDelegate: AddXChangeCoordinatorDelegate? = self
        let chatCoordinatorDelegate: ChatCoordinatorDelegate? = self
        let profileCoordinatorDelegate: ProfileCoordinatorDelegate? = self
        
        let mainCoordinator = container.resolve(MainCoordinator.self, argument: mainCoordinatorDelegate)!
        let favoriteCoordinator = container.resolve(FavoritesCoordinator.self, argument: favoriteCoordinatorDelegate)!
        let addXchangeCoordinator = container.resolve(AddXChangeCoordinator.self, argument: addXchangeCoordinatorDelegate)!
        let chatCoordinator = container.resolve(ChatCoordinator.self, argument: chatCoordinatorDelegate)!
        let profileCoordinator = container.resolve(ProfileCoordinator.self, argument: profileCoordinatorDelegate)!
        
        self.tabBarController = container.resolve(TabBarController.self, arguments: tabBarDelegate, mainCoordinator, favoriteCoordinator, addXchangeCoordinator, chatCoordinator, profileCoordinator)
        
        guard let tabBarController = tabBarController else { return }
        
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    func signOut(){
        authenticator?.signOut()
        goToLoginScreen()
    }
}

//MARK: LoginViewControllerDelegate
extension RootCoordinator: LoginViewControllerDelegate {
    func didSelectSignIn(with credentials: Credential, completion: @escaping (Error?) -> Void) {
        authenticator?.signIn(with: credentials) {[weak self] result in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(_):
                self?.goToTabBarController()
                completion(nil)
            }
        }
    }
    
    func didSelectForgotPassword(for email: String?, completion: @escaping (Error?) -> Void) {
        guard let email = email else { return }
        authenticator?.requestPasswordReset(for: email, completion: { error in
            completion(error)
        })
    }
    
    func didSelectSignUp() {
        goToSignUp()
    }
}

//MARK: SignUpViewControllerDelegate
extension RootCoordinator: SignUpViewControllerDelegate {
    
    func didSelectCreateAccount(with credentials: Credential, completion: @escaping (_ error: Error?) -> Void) {
        authenticator?.createUser(email: credentials.email,
                                  password: credentials.password,
                                  username: credentials.username){[weak self] error in
            if error == nil {
                self?.goToTabBarController()
            }
            completion(error)
        }
    }
    
    func shouldDismiss(_ viewController: SignUpViewController) {
        viewController.dismiss(animated: true)
    }
}

extension RootCoordinator: TabBarControllerDelegate {
    func navigateToDetailChatViewController(with chatId: String) {
    }
}

extension RootCoordinator: MainCoordinatorDelegate {
    func didSelectGoToDirectChat(with chatId: String) {
        guard let tabController = tabBarController else { return }
        tabController.selectedIndex = 3
        tabController.chatCoordinator.didSelectGoToDirectChat(with: chatId)
    }
    
    
}

extension RootCoordinator: FavoriteCoordinatorDelegate {
    
}

extension RootCoordinator: AddXChangeCoordinatorDelegate {
    
}

extension RootCoordinator: ChatCoordinatorDelegate {
    
}

extension RootCoordinator: ProfileCoordinatorDelegate {
    
}
