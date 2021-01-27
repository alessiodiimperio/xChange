//
//  LoginViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, Storyboarded {
    weak var coordinator:RootCoordinator?
    var viewModel:LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signInTapped(_ sender: Any) {
        coordinator?.signIn()
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        coordinator?.goToSignUp()
    }
}
