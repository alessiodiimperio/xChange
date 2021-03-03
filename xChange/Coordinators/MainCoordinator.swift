//
//  MainCoordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import UIKit
import Swinject
import SwinjectStoryboard
class MainCoordinator:Coordinator {
    let container = SwinjectStoryboard.defaultContainer
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    func start() {
        registerDependencies()
        let vc = container.resolve(MainViewController.self)!
        vc.tabBarItem.image = UIImage(systemName: "house.fill")
        vc.tabBarItem.title = "Home"
        navigationController.pushViewController(vc, animated: false)
    }
    
    func registerDependencies(){
        
        let mainStoryboard = SwinjectStoryboard.create(name: "Main", bundle: Bundle.main, container: container)
        container.register(MainViewModel.self) { _ in return MainViewModel()}
        container.register(MainViewController.self) { r in
            let controller = mainStoryboard.instantiateViewController(withIdentifier: String(describing: MainViewController.self)) as! MainViewController
            controller.viewModel = r.resolve(MainViewModel.self)
            return controller
        }
    }
    
}
