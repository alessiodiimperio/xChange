//
//  SignUpViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-01-28.
//

import RxSwift
import RxCocoa

class SignUpViewModel:ViewModelType {
    
    //Static vars
    
    let userNamePlaceholderText = "Username"
    let emailPlaceholderText = "Email"
    let passwordPlaceholderText = "Password"
    let createButtonTitle = "Create"
    
    //Reactive vars
    var errorLabelText = PublishSubject<String?>()
    
    struct Input {
        let createAccountTrigger:Driver<Void>
        let userNameTrigger:Driver<String?>
        let emailTrigger:Driver<String?>
        let passwordTrigger:Driver<String?>
        let errorLabelTrigger:Driver<String?>
    }
    struct Output {
        let onCreateBtnEnabled:Driver<Bool>
        let onCreateBtnTapped:Driver<Credential?>
        let onErrorLabel:Driver<String?>
    }
    
    func transform(_ input: Input) -> Output {
        Output(onCreateBtnEnabled: self.createBtnEnabled(input),
               onCreateBtnTapped: self.createAccountTapped(input),
               onErrorLabel: self.errorLabelAsDriver(input))
    }
    
    private func createBtnEnabled(_ input: Input) -> Driver<Bool>{
        Driver.combineLatest(input.userNameTrigger,
                             input.emailTrigger,
                             input.passwordTrigger) { userName, email, password in
            return Validate.textFieldInput(userName) && Validate.password(password) && Validate.email(email)
        }.asDriver(onErrorJustReturn: false)
    }
    private func createAccountTapped(_ input: Input) -> Driver<Credential?> {
        
        input.createAccountTrigger.withLatestFrom(Driver.combineLatest(input.userNameTrigger, input.emailTrigger, input.passwordTrigger).map { (username, email, password) -> Credential? in
            guard let username = username,
                  let email = email,
                  let password = password else { return nil }
            return Credential(username: username, email: email, password: password)
        })
    }
    private func errorLabelAsDriver(_ input: Input)->Driver<String?>{
        input.errorLabelTrigger.asDriver(onErrorJustReturn: "Error")
    }
}
