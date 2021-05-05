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

protocol LoginViewControllerDelegate: class {
    func didSelectSignIn(with Credentials: Credential, completion: @escaping (_ error: Error?) -> Void)
    func didSelectForgotPassword(for email: String?, completion: @escaping (_ error: Error?) -> Void)
    func didSelectSignUp()
}

class LoginViewController: BaseViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    
    let contentView: LoginView
    let viewModel:LoginViewModel
   
    init(view: LoginView, viewModel: LoginViewModel, delegate: LoginViewControllerDelegate?) {
        self.contentView = view
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTap()
    }

    override func setupObservables() {
        super.setupObservables()
        
        let output = viewModel.transform(LoginViewModel.Input(emailTrigger: contentView.emailTextField.rx.text.asDriver(),
                                                              passwordTrigger: contentView.passwordTextField.rx.text.asDriver(),
                                                              signInTrigger: contentView.signInBtn.rx.tap.asDriver(),
                                                              signUpTrigger: contentView.signUpBtn.rx.tap.asDriver(),
                                                              forgotPasswordTrigger: contentView.forgotPasswordBtn.rx.tap.asDriver(),
                                                              errorLabelTrigger: viewModel.errorLabelText.asDriver(onErrorJustReturn: "Error")
        ))
        
        output.onErrorLabel
            .drive(contentView.errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.onForgotPasswordEnabled
            .drive(contentView.forgotPasswordBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.onForgotPasswordEnabled
            .map { enabled -> CGFloat in
                enabled ? 1 : 0.4
            }.drive(contentView.forgotPasswordBtn.rx.alpha)
            .disposed(by: disposeBag)
        
        output.onIsSignInEnabled
            .drive(contentView.signInBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.onIsSignInEnabled
            .map { enabled -> CGFloat in
                enabled ? 1 : 0.4
            }.drive(contentView.signInBtn.rx.alpha)
            .disposed(by: disposeBag)
        
        output.onSignInTapped.drive(onNext: {[weak self] credentials in
            guard let credentials = credentials else { return }
            self?.delegate?.didSelectSignIn(with: credentials) { error in
                    self?.viewModel.errorLabelText.onNext(error?.localizedDescription)
            }
        }).disposed(by: disposeBag)
        
        output.onForgotPasswordTapped
            .drive(onNext: { [weak self] email in
                self?.delegate?.didSelectForgotPassword(for: email) { [weak self] error in
                    if error == nil {
                        self?.contentView.confirmPasswordResetSent()
                    } else {
                        self?.viewModel.errorLabelText.onNext(error?.localizedDescription)
                    }
                }
            }).disposed(by: disposeBag)
        
        output.onSignUpTapped
            .drive(onNext: {[weak self] in
                self?.delegate?.didSelectSignUp()
            }).disposed(by: disposeBag)
    }
}
