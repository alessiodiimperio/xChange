//
//  SignUpViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import UIKit
import RxSwift
import RxCocoa

protocol SignUpViewControllerDelegate: class {
    func didSelectCreateAccount(with credentials: Credential, completion: @escaping (_ error: Error?) -> Void)
    func shouldDismiss(_ viewController: SignUpViewController)
}

class SignUpViewController: BaseViewController, UITextFieldDelegate {
    
    weak var delegate: SignUpViewControllerDelegate?
    let viewModel:SignUpViewModel
    let contentView: SignUpView

    init(view: SignUpView, viewModel: SignUpViewModel, delegate: SignUpViewControllerDelegate?) {
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
        contentView.usernameTextField.becomeFirstResponder()
        hideKeyboardOnTap()
        contentView.setup(with: viewModel)
    }
    
    func becomeTextfieldDelegate(){
        contentView.usernameTextField.delegate = self
        contentView.emailTextField.delegate = self
        contentView.passwordTextField.delegate = self
    }

    override func setupObservables(){
        super.setupObservables()
        
        let output = viewModel.transform(SignUpViewModel.Input(createAccountTrigger: contentView.createBtn.rx.tap.asDriver(),
                                                               userNameTrigger: contentView.usernameTextField.rx.text.asDriver(),
                                                               emailTrigger: contentView.emailTextField.rx.text.asDriver(),
                                                               passwordTrigger: contentView.passwordTextField.rx.text.asDriver(),
                                                               errorLabelTrigger: viewModel.errorLabelText.asDriver(onErrorJustReturn: "Error")))
        output.onCreateBtnEnabled
            .drive(contentView.createBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.onErrorLabel
            .drive(contentView.errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.onCreateBtnEnabled
            .map { active in
                return active ? 1 : 0.4
            }.drive(contentView.createBtn.rx.alpha)
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

