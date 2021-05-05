//
//  FavoritesCoordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-26.
//

import UIKit
import Swinject
import SwinjectStoryboard

protocol FavoriteCoordinatorDelegate: AnyObject {    
}

class FavoritesCoordinator:Coordinator {
    let container: Container
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    weak var delegate: FavoriteCoordinatorDelegate?
    
    init(navigationController:UINavigationController, container: Container, delegate: FavoriteCoordinatorDelegate?){
        self.navigationController = navigationController
        self.container = container
        self.delegate = delegate
    }
    
    func start() {        
        let vc = container.resolve(FavoritesViewController.self)!
        vc.tabBarItem.image = UIImage(systemName: "heart.fill")
        vc.tabBarItem.title = "Favorites"
        navigationController.pushViewController(vc, animated: false)
    }
}
