//
//  TabBarController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import UIKit

class TabBarController: UITabBarController, Storyboarded {

    var mainCoordinator:MainCoordinator!
    var favoritesCoordinator:FavoritesCoordinator!
    var addXChangeCoordinator:AddXChangeCoordinator!
    var chatCoordinator:ChatCoordinator!
    var profileCoordinator:ProfileCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCoordinator.start()
        favoritesCoordinator.start()
        addXChangeCoordinator.start()
        chatCoordinator.start()
        profileCoordinator.start()
        
        viewControllers = [
            mainCoordinator.navigationController,
            favoritesCoordinator.navigationController,
            addXChangeCoordinator.navigationController,
            chatCoordinator.navigationController,
            profileCoordinator.navigationController
        ]
    }
}
