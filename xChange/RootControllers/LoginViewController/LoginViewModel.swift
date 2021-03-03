//
//  LoginViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import RxSwift
import RxCocoa

class LoginViewModel:ViewModelType{
        
    var errorLabelText = PublishSubject<String?>()
    
    struct Input {
        let emailTrigger:Driver<String?>
        let passwordTrigger:Driver<String?>
        let signInTrigger:Driver<Void>
        let signUpTrigger:Driver<Void>
        let forgotPasswordTrigger:Driver<Void>
        let errorLabelTrigger:Driver<String?>
    }
    struct Output {
        let onIsSignInEnabled:Driver<Bool>
        let onForgotPasswordEnabled:Driver<Bool>
        let onErrorLabel:Driver<String?>
        let onSignInTapped:Driver<Credential?>
        let onSignUpTapped:Driver<Void>
        let onForgotPasswordTapped:Driver<String?>
    }
    
    func transform(_ input: Input) -> Output {
        
        Output(onIsSignInEnabled: signInEnabledAsDriver(input),
                      onForgotPasswordEnabled: forgotPasswordEnabledAsDriver(input),
                      onErrorLabel: errorLabelAsDriver(input),
                      onSignInTapped: signInTappedAsDriver(input),
                      onSignUpTapped: signUpTappedAsDriver(input),
                      onForgotPasswordTapped: forgotPasswordTappedAsDriver(input))
    }
    
    private func signInEnabledAsDriver(_ input: Input) -> Driver<Bool>{
        Driver.combineLatest(input.emailTrigger, input.passwordTrigger).map { (email, password) -> Bool in
            return Validate.email(email) && Validate.password(password)
        }.asDriver(onErrorJustReturn: false)
    }
    
    private func forgotPasswordEnabledAsDriver(_ input: Input) -> Driver<Bool>{
        input.emailTrigger.asObservable().map { (email) -> Bool in
            return Validate.email(email)
        }.asDriver(onErrorJustReturn: false)
    }
    
    private func errorLabelAsDriver(_ input: Input) -> Driver<String?>{
        errorLabelText.asDriver(onErrorJustReturn: "Error")
    }
    
    private func signInTappedAsDriver(_ input: Input)->Driver<Credential?>{
        let credentials = Driver.combineLatest(input.emailTrigger, input.passwordTrigger).map { (email, password) -> Credential? in
            guard let email = email,
                  let password = password else { return nil }
            return Credential(username:"Unnamed", email: email, password: password)
        }.asDriver()
        
        return input.signInTrigger.withLatestFrom(credentials).asDriver(onErrorDriveWith: Driver.empty())
    }
    
    private func signUpTappedAsDriver(_ input: Input)->Driver<Void>{
        input.signUpTrigger.asDriver(onErrorJustReturn:())
    }
    
    private func forgotPasswordTappedAsDriver(_ input: Input)->Driver<String?>{
        input.forgotPasswordTrigger.withLatestFrom(input.emailTrigger).asDriver(onErrorJustReturn: "Error")
    }
}
