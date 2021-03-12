//
//  FavouritesAssembly.swift
//  xChange
//
//  Created by Alessio on 2021-03-09.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class FavouritesAssembly: Assembly {
    
    func assemble(container: Container) {
        assembleFavourites(container)
    }
        
    private func assembleFavourites(_ container: Container) {
        assembleViewModels(container)
        assembleViewControllers(container)
    }
    
    private func assembleViewModels(_ container: Container){
        container.register(FavoritesViewModel.self) { r in
            let favouritesProvider = r.resolve(FavoritesProvider.self)!
            return FavoritesViewModel(favouriteProvider: favouritesProvider)
        }
    }
    
    private func assembleViewControllers(_ container: Container){
        let favoritesStoryboard = SwinjectStoryboard.create(name: "Favorites", bundle: Bundle.main, container: container)
        
        container.register(FavoritesViewController.self) { r in
            let controller = favoritesStoryboard.instantiateViewController(withIdentifier: String(describing: FavoritesViewController.self)) as! FavoritesViewController
            controller.viewModel = r.resolve(FavoritesViewModel.self)
            return controller
        }
    }
}

