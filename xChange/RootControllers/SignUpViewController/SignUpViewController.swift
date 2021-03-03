//
//  SignUpViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController, UITextFieldDelegate, Storyboarded {
    
    weak var delegate: SignUpViewControllerDelegate?
    var viewModel:SignUpViewModel!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.becomeFirstResponder()
        hideKeyboardOnTap()
        setupObservables()
    }
    
    func becomeTextfieldDelegate(){
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}

//MARK: Bindings
extension SignUpViewController {
    func setupObservables(){
        let output = viewModel.transform(SignUpViewModel.Input(createAccountTrigger: createBtn.rx.tap.asDriver(),
                                                               userNameTrigger: usernameTextField.rx.text.asDriver(),
                                                               emailTrigger: emailTextField.rx.text.asDriver(),
                                                               passwordTrigger: passwordTextField.rx.text.asDriver(),
                                                               errorLabelTrigger: viewModel.errorLabelText.asDriver(onErrorJustReturn: "Error")))
        output.onCreateBtnEnabled
            .drive(createBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.onErrorLabel
            .drive(errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.onCreateBtnEnabled
            .map { active in
                return active ? 1 : 0.4
            }.drive(createBtn.rx.alpha)
            .disposed(by: disposeBag)
        
        output.onCreateBtnTapped
            .drive(onNext: {[weak self] credentials in
                guard let credentials = credentials,
                      let self = self else { return }
                self.delegate?.didSelectCreateAccount(with: credentials){ error in
                    if let error = error {
                        self.viewModel.errorLabelText.onNext(error.localizedDescription)
                    } else {
                        self.delegate?.shouldDismiss(self)
                    }
                }
            }).disposed(by: disposeBag)
    }
}

