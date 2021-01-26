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
    
    weak var container:Container?
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(container:Container, navigationController:UINavigationController){
        self.container = container
        self.navigationController = navigationController
    }
    func start() {
        registerDependencies()
        let vc = container!.resolve(MainViewController.self)!
        vc.tabBarItem.image = UIImage(systemName: "house.fill")
        vc.tabBarItem.title = "Home"
        navigationController.pushViewController(vc, animated: false)
    }
    
    func registerDependencies(){
        
        let mainStoryboard = SwinjectStoryboard.create(name: "Main", bundle: Bundle.main, container: container!)
        container!.register(MainViewModel.self) { _ in return MainViewModel()}
        container!.register(MainViewController.self) { r in
            let controller = mainStoryboard.instantiateViewController(withIdentifier: String(describing: MainViewController.self)) as! MainViewController
            controller.viewModel = r.resolve(MainViewModel.self)
            return controller
        }
    }
    
}
