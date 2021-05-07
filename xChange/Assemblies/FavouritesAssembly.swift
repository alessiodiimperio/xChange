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
        assembleViews(container)
        assembleViewModels(container)
        assembleViewControllers(container)
    }
    
    private func assembleViews(_ container: Container) {
        container.register(FavoritesView.self) { _ in
            FavoritesView()
        }
    }
    
    private func assembleViewModels(_ container: Container){
        container.register(FavoritesViewModel.self) { r in
            let favouritesProvider = r.resolve(FavoritesProvider.self)!
            return FavoritesViewModel(favouriteProvider: favouritesProvider)
        }
    }
    
    private func assembleViewControllers(_ container: Container){
        container.register(FavoritesViewController.self) { (r, delegate: FavouritesViewControllerDelegate?) in
            let view = r.resolve(FavoritesView.self)!
            let viewModel = r.resolve(FavoritesViewModel.self)!
            
            return FavoritesViewController(view: view,
                                           viewModel: viewModel,
                                           delegate: delegate)
        }
    }
}

