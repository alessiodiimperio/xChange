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
        
        container.register(DetailView.self) { _ in
            DetailView()
        }
    }
    
    private func assembleViewModels(_ container: Container){
        container.register(MainViewModel.self) { r in
            let dataProvider = r.resolve(DataProvider.self)!
            let favouriteProvider = r.resolve(FavoritesProvider.self)!
            return MainViewModel(dataProvider: dataProvider,
                                 favoriteProvider: favouriteProvider)
        }
        
        container.register(DetailViewModel.self) { (r: Resolver, xChange: XChange) in
            let authProvider = r.resolve(AuthenticationProvider.self)!
            let favoriteProvider = r.resolve(FavoritesProvider.self)!
            let dataProvider = r.resolve(DataProvider.self)!
            let chatProvider = r.resolve(ChatProvider.self)!
            
            return DetailViewModel(xChange,
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
        
        container.register(DetailViewController.self) { (r: Resolver, xChange: XChange, delegate: DetailViewControllerDelegate?) in
            let view = r.resolve(DetailView.self)!
            let viewModel = r.resolve(DetailViewModel.self, argument: xChange)!
            
            return DetailViewController(view: view,
                                            viewModel: viewModel,
                                            delegate: delegate)
        }
    }
}
