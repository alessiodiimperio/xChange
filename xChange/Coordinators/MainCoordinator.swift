//
//  MainCoordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import UIKit
import Swinject
import SwinjectStoryboard

protocol MainCoordinatorDelegate: AnyObject {
    func didSelectGoToDirectChat(with chatId: String)
}

class MainCoordinator:Coordinator {
    let container: Container
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    weak var delegate: MainCoordinatorDelegate?
    
    init(navigationController:UINavigationController, container: Container, delegate: MainCoordinatorDelegate?){
        self.navigationController = navigationController
        self.container = container
        self.delegate = delegate
    }
    
    func start() {
        let delegate: MainViewControllerDelegate? = self
        let vc = container.resolve(MainViewController.self, argument: delegate)!
        vc.tabBarItem.image = UIImage(systemName: "house.fill")
        vc.tabBarItem.title = "Home"
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToMainDetailView(for xChange: XChange) {
        let delegate: MainDetailViewControllerDelegate? = self
        let vc = container.resolve(MainDetailViewController.self, arguments: xChange, delegate)!
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MainCoordinator: MainViewControllerDelegate {
    func handleDidSelectTableViewItem(xChange: XChange) {
        self.goToMainDetailView(for: xChange)
    }
}

extension MainCoordinator: MainDetailViewControllerDelegate {
    func didSelectGoToDirectChat(with chatId: String) {
        delegate?.didSelectGoToDirectChat(with: chatId)
    }
}
