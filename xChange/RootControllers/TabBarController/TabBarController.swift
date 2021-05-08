//
//  TabBarController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import UIKit

protocol TabBarControllerDelegate: AnyObject {
}

class TabBarController: UITabBarController {

    weak var tabBarDelegate: TabBarControllerDelegate?
    
    var mainCoordinator:MainCoordinator
    var favoritesCoordinator:FavoritesCoordinator
    var addXChangeCoordinator:AddXChangeCoordinator
    var chatCoordinator:ChatCoordinator
    var profileCoordinator:ProfileCoordinator
    
    init(delegate: TabBarControllerDelegate?,
         mainCoordinator: MainCoordinator,
         favouriteCoordinator: FavoritesCoordinator,
         addXChangeCoordinator: AddXChangeCoordinator,
         chatCoordinator: ChatCoordinator,
         profileCoordinator: ProfileCoordinator) {
        
        self.tabBarDelegate = delegate
        self.mainCoordinator = mainCoordinator
        self.favoritesCoordinator = favouriteCoordinator
        self.addXChangeCoordinator = addXChangeCoordinator
        self.chatCoordinator = chatCoordinator
        self.profileCoordinator = profileCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .mainNavigationColor
        tabBar.tintColor = .mainActiveTintColor
        tabBar.unselectedItemTintColor = .mainClickableTintColor

        
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
