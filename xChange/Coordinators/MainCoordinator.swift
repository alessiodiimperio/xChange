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
    let container: Container
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(navigationController:UINavigationController, container: Container){
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let vc = container.resolve(MainViewController.self)!
        vc.delegate = self
        vc.tabBarItem.image = UIImage(systemName: "house.fill")
        vc.tabBarItem.title = "Home"
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToMainDetailView(for xChange: XChange) {
        let vc = container.resolve(MainDetailViewController.self, argument: xChange)!
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MainCoordinator: MainViewControllerDelegate {
    func handleDidSelectTableViewItem(xChange: XChange) {
        self.goToMainDetailView(for: xChange)
    }
}
