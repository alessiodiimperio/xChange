//
//  AddXChangeAssembly.swift
//  xChange
//
//  Created by Alessio on 2021-03-09.
//

import Foundation
import Swinject
import SwinjectStoryboard


final class AddXChangeAssembly: Assembly {
    
    func assemble(container: Container) {
        assembleAddXChange(container)
    }
        
    private func assembleAddXChange(_ container: Container) {
        assembleViews(container)
        assembleViewModels(container)
        assembleViewControllers(container)
    }
    
    private func assembleViews(_ container: Container) {
        container.register(AddXChangeView.self) { _ in
            AddXChangeView()
        }
    }
    
    private func assembleViewModels(_ container: Container){
        container.register(AddXChangeViewModel.self){r in
            AddXChangeViewModel(xChangeService: r.resolve(DataProvider.self)!,
                                authenticationService: r.resolve(AuthenticationProvider.self)!
            )
        }
    }
    
    private func assembleViewControllers(_ container: Container){
        container.register(AddXChangeController.self) { (r, delegate: AddXChangeViewControllerDelegate?) in
            let view = r.resolve(AddXChangeView.self)!
            let viewModel = r.resolve(AddXChangeViewModel.self)!
            return AddXChangeController(view: view,
                                        viewModel: viewModel,
                                        delegate: delegate)
        }
    }
}
