//
//  TestLoginViewController.swift
//  xChangeSnapShotTests
//
//  Created by Alessio on 2021-05-11.
//

import UIKit
import Quick
import Nimble
import Nimble_Snapshots

@testable import xChange

class TestLoginViewController: QuickSpec {
    
    override var shouldRecordAllSnapshots: Bool { return false }
        
    override func spec() {
    
        var view: LoginView!
        var viewController: LoginViewController!
        var viewModel: LoginViewModel!
        
        beforeEach {
            setNimbleTolerance(0)
            setNimbleTestFolder("tests")
        }
        
        describe("LoginView") {
    
            beforeEach {
                let resolver = AppAssembler.shared.resolver
                let delegate: LoginViewControllerDelegate? = MockLoginViewControllerDelegate()
                let viewController = resolver.resolve(LoginViewController.self, argument: delegate)!
                view = viewController.contentView
                viewModel = viewController.viewModel
                UIApplication.shared.keyWindow?.rootViewController = viewController
            }
            
            context("by default") {
                it("has a valid snapshot") {
                    if self.shouldRecordSnapshot(false) {
                        expect(view).to(recordDeviceAgnosticSnapshot())
                    } else {
                        expect(view).to(haveValidDeviceAgnosticSnapshot())
                    }
                }
            }
            
            context("with error labels for input fields") {
                
                beforeEach {
                    view.errorLabel.text = "This is an error"
                }
                
                it("has a valid snapshot") {
                    if self.shouldRecordSnapshot(false) {
                        expect(view).to(recordDeviceAgnosticSnapshot())
                    } else {
                        expect(view).to(haveValidDeviceAgnosticSnapshot())
                    }
                }
            }
        }
    }
}

private class MockLoginViewControllerDelegate: LoginViewControllerDelegate {
    func didSelectSignIn(with Credentials: Credential, completion: @escaping (Error?) -> Void) {
        
    }
    
    func didSelectForgotPassword(for email: String?, completion: @escaping (Error?) -> Void) {
        
    }
    
    func didSelectSignUp() {
        
    }
    
    
}
