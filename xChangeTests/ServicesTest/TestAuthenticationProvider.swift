//
//  TestAuthenticationProvider.swift
//  xChangeTests
//
//  Created by Alessio on 2021-05-09.
//

import Foundation
import Quick
import Nimble

@testable import xChange

final class TestAuthenticationProvider: QuickSpec {
    
    override func spec() {
        let resolver = AppAssembler.shared.resolver
        let authenticationProvider = resolver.resolve(AuthenticationProvider.self)!
        
        describe("AuthenticationProvider") {
            context("Given correct test email password for sign in") {
                it("should not return error"){
                    waitUntil(timeout: DispatchTimeInterval.seconds(30), action: { (done) in
                        authenticationProvider.signIn(with: Credential(username: "Nobody", email: "fakeuser@applicationdomain.com", password: "123456")) { result in
                            switch result {
                            case.success(let success):
                                expect(success).to(beTrue())
                                done()
                            case .failure(let error):
                                expect(error).to(beNil())
                                done()
                            }
                        }
                    })
                }
            }
            
            context("Given wrong test email password for sign in") {
                it("should return error"){
                    waitUntil(timeout: DispatchTimeInterval.seconds(30), action: { (done) in
                        authenticationProvider.signIn(with: Credential(username: "Nobody", email: "nouser@nodomain.com", password: "123456")) { result in
                            switch result {
                            case.success(let success):
                                expect(success).to(beFalse())
                                done()
                            case .failure(let error):
                                expect(error).toNot(beNil())
                                done()
                            }
                        }
                    })
                }
            }
            
            context("Given correct test userId") {
                it("should return user document"){
                    waitUntil(timeout: DispatchTimeInterval.seconds(30), action: { (done) in
                        authenticationProvider.getUser(for: "ceJuNRfPFxg6sZLW2UgO2B0MIdy1") { user in
                            expect(user).toNot(beNil())
                            done()
                        }
                    })
                }
            }
            
            context("Given false test userId") {
                it("should not return user document"){
                    waitUntil(timeout: DispatchTimeInterval.seconds(30), action: { (done) in
                        authenticationProvider.getUser(for: "notARealUID") { user in
                            expect(user).to(beNil())
                            done()
                        }
                    })
                }
            }
            
            context("Requesting password reset with incorrect email") {
                it("should return error"){
                    waitUntil(timeout: DispatchTimeInterval.seconds(30), action: { (done) in
                        authenticationProvider.requestPasswordReset(for: "wrong@email.com") { error in
                            expect(error).toNot(beNil())
                            done()
                        }
                    })
                }
            }
            
            context("Requesting password reset with incorrect email") {
                it("should return error"){
                    waitUntil(timeout: DispatchTimeInterval.seconds(30), action: { (done) in
                        authenticationProvider.requestPasswordReset(for: "fakeuser@applicationdomain.com") { error in
                            expect(error).to(beNil())
                            done()
                        }
                    })
                }
            }
        }
    }
}
