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
        assembleViewModels(container)
        assembleViewControllers(container)
    }
    
    private func assembleViewModels(_ container: Container){
        container.register(AddXChangeViewModel.self){r in
            AddXChangeViewModel(xChangeService: r.resolve(DataProvider.self)!,
                                authenticationService: r.resolve(AuthenticationProvider.self)!
            )
        }
    }
    
    private func assembleViewControllers(_ container: Container){
        let addXChangeStoryboard = SwinjectStoryboard.create(name: "AddXChange", bundle: Bundle.main, container: container)
        
        container.register(AddXChangeController.self) { r in
            let controller = addXChangeStoryboard.instantiateViewController(withIdentifier: String(describing: AddXChangeController.self)) as! AddXChangeController
            controller.viewModel = r.resolve(AddXChangeViewModel.self)
            return controller
        }
    }
}
