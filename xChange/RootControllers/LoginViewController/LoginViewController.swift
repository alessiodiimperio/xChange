//
//  LoginViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

class LoginViewController: UIViewController, Storyboarded {
    
    weak var delegate: LoginViewControllerDelegate?
    
    var viewModel:LoginViewModel!
    let disposebag = DisposeBag()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservables()
        hideKeyboardOnTap()
    }
}
extension LoginViewController {
    private func setupObservables(){
        
        
        
        let output = viewModel.transform(LoginViewModel.Input(emailTrigger: emailTextField.rx.text.asDriver(),
                                                              passwordTrigger: passwordTextField.rx.text.asDriver(),
                                                              signInTrigger: signInBtn.rx.tap.asDriver(),
                                                              signUpTrigger: signUpBtn.rx.tap.asDriver(),
                                                              forgotPasswordTrigger: forgotPasswordBtn.rx.tap.asDriver(),
                                                              errorLabelTrigger: viewModel.errorLabelText.asDriver(onErrorJustReturn: "Error")
        ))
        
        output.onErrorLabel
            .drive(errorLabel.rx.text)
            .disposed(by: disposebag)
        
        output.onForgotPasswordEnabled
            .drive(forgotPasswordBtn.rx.isEnabled)
            .disposed(by: disposebag)
        
        output.onForgotPasswordEnabled
            .map { enabled -> CGFloat in
                enabled ? 1 : 0.4
            }.drive(forgotPasswordBtn.rx.alpha)
            .disposed(by: disposebag)
        
        output.onIsSignInEnabled
            .drive(signInBtn.rx.isEnabled)
            .disposed(by: disposebag)
        
        output.onIsSignInEnabled
            .map { enabled -> CGFloat in
                enabled ? 1 : 0.4
            }.drive(signInBtn.rx.alpha)
            .disposed(by: disposebag)
        
        output.onSignInTapped.drive(onNext: {[weak self] credentials in
            guard let credentials = credentials else { return }
            self?.delegate?.didSelectSignIn(with: credentials) { error in
                    self?.viewModel.errorLabelText.onNext(error?.localizedDescription)
            }
        }).disposed(by: disposebag)
        
        output.onForgotPasswordTapped
            .drive(onNext: { [weak self] email in
                self?.delegate?.didSelectForgotPassword(for: email) { error in
                    self?.viewModel.errorLabelText.onNext(error?.localizedDescription)
                }
            }).disposed(by: disposebag)
        
        output.onSignUpTapped
            .drive(onNext: {[weak self] in
                self?.delegate?.didSelectSignUp()
            }).disposed(by: disposebag)
    }
}
