//
//  SignUpViewControllerDelegate.swift
//  xChange
//
//  Created by Alessio on 2021-02-21.
//

import Foundation
protocol SignUpViewControllerDelegate: class {
    func didSelectCreateAccount(with credentials: Credential, completion: @escaping (_ error: Error?) -> Void)
    func shouldDismiss(_ viewController: SignUpViewController)
}
