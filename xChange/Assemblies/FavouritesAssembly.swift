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
        container.register(FavoritesViewController.self) { r in
            let viewModel = r.resolve(FavoritesViewModel.self)!
            return FavoritesViewController(viewModel: viewModel)
        }
    }
}

