//
//  CoordinatorAssembly.swift
//  xChange
//
//  Created by Alessio on 2021-03-09.
//

import Foundation
import Swinject

final class CoordinatorAssembly: Assembly {
    
    func assemble(container: Container) {
        assembleCoordinators(container)
    }
        
    private func assembleCoordinators(_ container: Container) {
        assembleRootCoordinator(container)
        assembleMainCoordinator(container)
        assembleFavoritesCoordinator(container)
        assembleAddXChangeCoordinator(container)
        assembleChatCoordinator(container)
        assembleProfileCoordinator(container)
    }
    
    private func assembleRootCoordinator(_ container: Container) {
        container.register(RootNavigationController.self) {_ in
            RootNavigationController()
        }
        
        container.register(RootCoordinator.self) { r in
            let navigationController = r.resolve(RootNavigationController.self)!
            return RootCoordinator(navigationController: navigationController,
                                   container: container)
        }
    }
    
    private func assembleMainCoordinator(_ container: Container) {
        container.register(MainCoordinator.self){ (_, delegate: MainCoordinatorDelegate?) in
            
            let navigationController = UINavigationController()
            return MainCoordinator(navigationController: navigationController,
                                   container: container,
                                   delegate: delegate)
        }
    }
    
    private func assembleFavoritesCoordinator(_ container: Container) {
        container.register(FavoritesCoordinator.self){ (_, delegate: FavoriteCoordinatorDelegate?) in
            
            let navigationController = UINavigationController()
            return FavoritesCoordinator(navigationController: navigationController,
                                        container: container,
                                        delegate: delegate)
        }
    }
    
    private func assembleAddXChangeCoordinator(_ container: Container) {
        container.register(AddXChangeCoordinator.self){ (_, delegate: AddXChangeCoordinatorDelegate?) in
            
            let navigationController = UINavigationController()
            return AddXChangeCoordinator(navigationController: navigationController,
                                         container: container,
                                         delegate: delegate)
        }
    }
    
    private func assembleChatCoordinator(_ container: Container) {
        container.register(ChatCoordinator.self){ (_, delegate: ChatCoordinatorDelegate?) in
            
            let navigationController = UINavigationController()
            return ChatCoordinator(navigationController: navigationController,
                                   container: container,
                                   delegate: delegate)
        }
    }
    
    private func assembleProfileCoordinator(_ container: Container) {
        container.register(ProfileCoordinator.self){ (_, delegate: ProfileCoordinatorDelegate?) in
            
            let navigationController = UINavigationController()
            return ProfileCoordinator(navigationController: navigationController,
                                      container: container,
                                      delegate: delegate)
        }
    }
}

