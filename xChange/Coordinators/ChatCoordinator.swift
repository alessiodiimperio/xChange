//
//  ChatCoordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-26.
//

import UIKit
import Swinject
import SwinjectStoryboard

protocol ChatCoordinatorDelegate: AnyObject {
}

class ChatCoordinator:Coordinator {
    let container: Container
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    weak var delegate: ChatCoordinatorDelegate?
    
    init(navigationController:UINavigationController, container: Container, delegate: ChatCoordinatorDelegate?){
        self.container = container
        self.navigationController = navigationController
        self.delegate = delegate
    }
    
    func start() {
        let delegate: ChatViewControllerDelegate? = self
        let vc = container.resolve(ChatViewController.self, argument: delegate)!
        vc.tabBarItem.image = UIImage(systemName: "message.fill")
        vc.tabBarItem.title = "Chat"
        navigationController.pushViewController(vc, animated: false)
    }
    
    func didSelectGoToDirectChat(with chatId: String) {
        navigationController.popToRootViewController(animated: false)
        let delegate: DirectChatViewControllerDelegate? = self
        let directChatViewController = container.resolve(DirectChatViewController.self, arguments: chatId, delegate)!
        navigationController.pushViewController(directChatViewController, animated: true)
    }
}

extension ChatCoordinator: DirectChatViewControllerDelegate {
    
    func shouldDismiss(_ viewController: BaseViewController) {
        viewController.dismiss(animated: true)
    }
}

extension ChatCoordinator: ChatViewControllerDelegate {
    // Conforming to protocol implementation already exists in base class
}
