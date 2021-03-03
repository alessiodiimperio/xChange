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
    let disposeBag = DisposeBag()
    let container = SwinjectStoryboard.defaultContainer
    var navigationController:UINavigationController
    var childrenCoordinators:[Coordinator] = [Coordinator]()
    let authenticator:AuthenticationProvider?
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
        self.authenticator = container.resolve(AuthenticationProvider.self)
    }
    
    func start() {
        navigationController.navigationBar.isHidden = true
        guard let auth = authenticator else { fatalError() }
        
        auth.isSignedIn() ? goToTabBarController() : goToLoginScreen()
    }
    
    func goToLoginScreen(){
        let loginViewController = LoginViewController.instatiate(from: .rootStoryboard)
        loginViewController.delegate = self
        navigationController.setViewControllers([loginViewController], animated: false)
    }
    func goToSignUp(){
        let signUpViewController = SignUpViewController.instatiate(from: .rootStoryboard)
        signUpViewController.delegate = self
        navigationController.present(signUpViewController, animated: true)
    }
    func goToTabBarController(){
        let tabBarController = TabBarController.instatiate(from: .rootStoryboard)
        tabBarController.profileCoordinator.parentCoordinator = self
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
        let signUpViewController = SignUpViewController.instatiate(from: .rootStoryboard)
        signUpViewController.delegate = self
        navigationController.present(signUpViewController, animated: true)
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
