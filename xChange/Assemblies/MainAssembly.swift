//
//  MainAssembly.swift
//  xChange
//
//  Created by Alessio on 2021-03-09.
//
import Swinject
import SwinjectStoryboard
import Foundation

final class MainAssembly: Assembly {
    
    func assemble(container: Container) {
        assembleMain(container)
    }
        
    private func assembleMain(_ container: Container) {
        assembleViewModels(container)
        assembleViewControllers(container)
    }
    
    private func assembleViewModels(_ container: Container){
        container.register(MainViewModel.self) { r in
            let feedprovider = r.resolve(FeedProvider.self)!
            let favouriteProvider = r.resolve(FavoritesProvider.self)!
            return MainViewModel(feedProvider: feedprovider, favoriteProvider: favouriteProvider)
        }
        
        container.register(MainDetailViewModel.self) { (r: Resolver, xChange: XChange) in
            let authProvider = r.resolve(AuthenticationProvider.self)!
            let favoriteProvider = r.resolve(FavoritesProvider.self)!
            let dataProvider = r.resolve(DataProvider.self)!
            return MainDetailViewModel(xChange,
                                       authProvider: authProvider,
                                       favoriteProvider: favoriteProvider,
                                       dataProvider: dataProvider)
        }
    }
    
    private func assembleViewControllers(_ container: Container){
        
        container.register(MainViewController.self) { r in
            let viewModel = r.resolve(MainViewModel.self)!
            return MainViewController(viewModel: viewModel)
        }
        
        container.register(MainDetailViewController.self) { (r: Resolver, xChange: XChange) in
            let viewModel = r.resolve(MainDetailViewModel.self, argument: xChange)!
            return MainDetailViewController(viewModel: viewModel)
        }
    }
}
