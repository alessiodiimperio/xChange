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
        assembleViews(container)
        assembleViewModels(container)
        assembleViewControllers(container)
    }
    
    private func assembleViews(_ container: Container) {
        container.register(MainView.self) { _ in
            MainView()
        }
        
        container.register(MainDetailView.self) { _ in
            MainDetailView()
        }
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
            let chatProvider = r.resolve(ChatProvider.self)!
            
            return MainDetailViewModel(xChange,
                                       authProvider: authProvider,
                                       favoriteProvider: favoriteProvider,
                                       dataProvider: dataProvider,
                                       chatProvider: chatProvider)
        }
    }
    
    private func assembleViewControllers(_ container: Container){
        
        container.register(MainViewController.self) { (r, delegate: MainViewControllerDelegate?) in
            let view = r.resolve(MainView.self)!
            let viewModel = r.resolve(MainViewModel.self)!
            
            return MainViewController(view: view,
                                      viewModel: viewModel,
                                      delegate: delegate)
        }
        
        container.register(MainDetailViewController.self) { (r: Resolver, xChange: XChange, delegate: MainDetailViewControllerDelegate?) in
            let view = r.resolve(MainDetailView.self)!
            let viewModel = r.resolve(MainDetailViewModel.self, argument: xChange)!
            
            return MainDetailViewController(view: view,
                                            viewModel: viewModel,
                                            delegate: delegate)
        }
    }
}
