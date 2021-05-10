//
//  TestLoginView.swift
//  xChangeTests
//
//  Created by Alessio on 2021-05-10.
//

import Quick
import Nimble
import Nimble_Snapshots
import UIKit

@testable import xChange

class TestLoginView: QuickSpec {
    
    override var shouldRecordAllSnapshots: Bool { return false }
    
    override func spec() {
        let resolver = AppAssembler.shared.resolver
        
        let view: UIView!
        let viewModel: ViewModelType!
        let viewController: BaseViewController!
        
        beforeEach {
            setNimbleTolerance(0)
            setNimbleTestFolder("tests")
        }
        
        describe("LoginView") {
            
            
            beforeEach {
                
            }
            
            it("view has a valid snapshot") {
                if self.shouldRecordSnapshot(false) {
                    expect(view).to(recordDeviceAgnosticSnapshot())
                } else {
                    expect(view).to(haveValidDeviceAgnosticSnapshot())
                }
            }
        }
    }
}

private class MockLoginViewControllerDelegate: MockLoginViewControllerDelegate {
    
}
