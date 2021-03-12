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
    let container: Container
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(navigationController:UINavigationController, container: Container){
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let vc = container.resolve(AddXChangeController.self)!
        vc.tabBarItem.image = UIImage(systemName: "arrow.up.arrow.down")
        vc.tabBarItem.title = "xChange"
        navigationController.pushViewController(vc, animated: false)
        navigationController.isNavigationBarHidden = true
    }
}
