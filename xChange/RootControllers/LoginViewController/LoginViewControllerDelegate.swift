//
//  LoginViewControllerDelegate.swift
//  xChange
//
//  Created by Alessio on 2021-02-21.
//

import Foundation
protocol LoginViewControllerDelegate: class {
    func didSelectSignIn(with Credentials: Credential, completion: @escaping (_ error: Error?) -> Void)
    func didSelectForgotPassword(for email: String?, completion: @escaping (_ error: Error?) -> Void)
    func didSelectSignUp()
}
