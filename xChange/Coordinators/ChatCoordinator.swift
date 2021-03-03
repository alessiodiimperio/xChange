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
    let container = SwinjectStoryboard.defaultContainer
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    
    init(navigationController:UINavigationController){
        
        self.navigationController = navigationController
    }
    func start() {
        registerDependencies()
        let vc = container.resolve(ChatViewController.self)!
        vc.tabBarItem.image = UIImage(systemName: "message.fill")
        vc.tabBarItem.title = "Chat"
        navigationController.pushViewController(vc, animated: false)
    }
    func registerDependencies(){
        let chatStoryboard = SwinjectStoryboard.create(name: "Chat", bundle: Bundle.main, container: container)
        container.register(ChatViewModel.self){_ in return ChatViewModel()}
        container.register(ChatViewController.self) { r in
            let controller = chatStoryboard.instantiateViewController(withIdentifier: String(describing: ChatViewController.self)) as! ChatViewController
            controller.viewModel = r.resolve(ChatViewModel.self)
            return controller
        }
        
    }
}
