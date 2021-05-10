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
    func didSelectToGoToDirectChat(with chatId: String)
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
        let delegate: FavouritesViewControllerDelegate? = self
        let vc = container.resolve(FavoritesViewController.self, argument: delegate)!
        navigationController.tabBarItem.image = UIImage(systemName: "heart.fill")
        navigationController.tabBarItem.title = "Favorites"
        navigationController.setViewControllers([vc], animated: false)
    }
}

extension FavoritesCoordinator: FavouritesViewControllerDelegate {
    
    func didSelectFavourite(_ xChange: XChange) {
        let delegate: DetailViewControllerDelegate? = self
        let favouriteDetailViewController = container.resolve(DetailViewController.self, arguments: xChange, delegate)!
        navigationController.pushViewController(favouriteDetailViewController, animated: true)
    }
}

extension FavoritesCoordinator: DetailViewControllerDelegate {
    func didSelectXchangeSold(in viewController: BaseViewController) {
    }
    
    
    func didSelectGoToDirectChat(with chatId: String) {
        let delegate: DirectChatViewControllerDelegate? = self
        let directChatViewController = container.resolve(DirectChatViewController.self, arguments: chatId, delegate)!
        navigationController.pushViewController(directChatViewController, animated: true)
    }
}

extension FavoritesCoordinator: DirectChatViewControllerDelegate {
    func shouldDismiss(_ viewController: BaseViewController) {
        viewController.dismiss(animated: true)
    }
}
