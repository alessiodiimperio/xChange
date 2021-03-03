//
//  AddXChangeCoordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-26.
//

import UIKit
import Swinject
import SwinjectStoryboard

class AddXChangeCoordinator:Coordinator {
    let container = SwinjectStoryboard.defaultContainer
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        registerDependencies()
        let vc = container.resolve(AddXChangeController.self)!
        vc.tabBarItem.image = UIImage(systemName: "arrow.up.arrow.down")
        vc.tabBarItem.title = "xChange"
        navigationController.pushViewController(vc, animated: false)
        navigationController.isNavigationBarHidden = true
    }
    
    func registerDependencies(){
        let addXChangeStoryboard = SwinjectStoryboard.create(name: "AddXChange", bundle: Bundle.main, container: container)
        container.register(AddXChangeViewModel.self){r in
            AddXChangeViewModel(xChangeService: r.resolve(DataProvider.self)!,
                                authenticationService: r.resolve(AuthenticationProvider.self)!
            )
        }
        container.register(AddXChangeController.self) { r in
            let controller = addXChangeStoryboard.instantiateViewController(withIdentifier: String(describing: AddXChangeController.self)) as! AddXChangeController
            controller.viewModel = r.resolve(AddXChangeViewModel.self)
            return controller
        }
    }
}
