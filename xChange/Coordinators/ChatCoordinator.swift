//
//  ChatCoordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-26.
//

import UIKit
import Swinject
import SwinjectStoryboard

class ChatCoordinator:Coordinator {
    let container: Container
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(navigationController:UINavigationController, container: Container){
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = container.resolve(ChatViewController.self)!
        vc.tabBarItem.image = UIImage(systemName: "message.fill")
        vc.tabBarItem.title = "Chat"
        navigationController.pushViewController(vc, animated: false)
    }
}
