//
//  FavoritesCoordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-26.
//

import UIKit
import Swinject
import SwinjectStoryboard

class FavoritesCoordinator:Coordinator {
    let container = SwinjectStoryboard.defaultContainer
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    func start() {
        registerDependencies()
        
        let vc = container.resolve(FavoritesViewController.self)!
        vc.tabBarItem.image = UIImage(systemName: "heart.fill")
        vc.tabBarItem.title = "Favorites"
        navigationController.pushViewController(vc, animated: false)
    }
    func registerDependencies(){
        let favoritesStoryboard = SwinjectStoryboard.create(name: "Favorites", bundle: Bundle.main, container: container)
        
        container.register(FavoritesViewModel.self) { _ in return FavoritesViewModel()}
        container.register(FavoritesViewController.self) { r in
            let controller = favoritesStoryboard.instantiateViewController(withIdentifier: String(describing: FavoritesViewController.self)) as! FavoritesViewController
            controller.viewModel = r.resolve(FavoritesViewModel.self)
            return controller
        }
        
    }
}
