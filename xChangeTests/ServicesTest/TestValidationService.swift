//
//  TestValidationService.swift
//  xChangeTests
//
//  Created by Alessio on 2021-05-09.
//

import Foundation
import Quick
import Nimble

@testable import xChange

final class TestValidationService: QuickSpec {
    
    override func spec() {
        
        describe("ValidationService") {
            context("given incorrect email values") {
                it("should return false") {
                    expect(Validate.email("123")).to(beFalse())
                    expect(Validate.email("abc")).to(beFalse())
                    expect(Validate.email("123.abc")).to(beFalse())
                    expect(Validate.email("1@2.3")).to(beFalse())
                    expect(Validate.email("www.url.com")).to(beFalse())
                    expect(Validate.email("username@domain.x")).to(beFalse())
                    expect(Validate.email("username@domain")).to(beFalse())
                    expect(Validate.email("username.domain.com")).to(beFalse())
                    expect(Validate.email("username.domain@com")).to(beFalse())
                }
            }
            
            context("given correct email values") {
                it("should return true") {
                    expect(Validate.email("username@domain.com")).to(beTrue())
                    expect(Validate.email("username@domain.se")).to(beTrue())
                    expect(Validate.email("username@domain.com.au")).to(beTrue())
                }
            }
            
            context("given incorrect password values") {
                it("should return false") {
                    expect(Validate.password(nil)).to(beFalse())
                    expect(Validate.password("")).to(beFalse())
                }
            }
            
            context("given correct password values") {
                it("should return true") {
                    expect(Validate.password("123456")).to(beTrue())
                }
            }
            
            context("given bad textfield input") {
                it("should be false") {
                    expect(Validate.textFieldInput(nil)).to(beFalse())
                    expect(Validate.textFieldInput("")).to(beFalse())
                }
            }
            
            context("given valid textfield input") {
                it("should be true") {
                    expect(Validate.textFieldInput("abc")).to(beTrue())
                }
            }
        }
    }
}
