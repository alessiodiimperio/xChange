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
    
    weak var container:Container?
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(container:Container, navigationController:UINavigationController){
        self.container = container
        self.navigationController = navigationController
    }
    func start() {
        registerDependencies()
        let vc = container!.resolve(AddXChangeController.self)!
        vc.tabBarItem.image = UIImage(systemName: "arrow.up.arrow.down")
        vc.tabBarItem.title = "xChange"
        navigationController.pushViewController(vc, animated: false)
    }
    func registerDependencies(){
        let addXChangeStoryboard = SwinjectStoryboard.create(name: "AddXChange", bundle: Bundle.main, container: container!)
        container!.register(AddXChangeViewModel.self){_ in return AddXChangeViewModel()}
        container!.register(AddXChangeController.self) { r in
            let controller = addXChangeStoryboard.instantiateViewController(withIdentifier: String(describing: AddXChangeController.self)) as! AddXChangeController
            controller.viewModel = r.resolve(AddXChangeViewModel.self)
            return controller
        }
    }
}
