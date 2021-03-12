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
    }
    
    private func assembleViewControllers(_ container: Container){
        let mainStoryboard = SwinjectStoryboard.create(name: "Main", bundle: Bundle.main, container: container)
        
        container.register(MainViewController.self) { r in
            let controller = mainStoryboard.instantiateViewController(withIdentifier: String(describing: MainViewController.self)) as! MainViewController
            controller.viewModel = r.resolve(MainViewModel.self)
            return controller
        }
    }
}
