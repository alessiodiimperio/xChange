//
//  ProfileAssembly.swift
//  xChange
//
//  Created by Alessio on 2021-03-09.
//

import Foundation
import Swinject
import SwinjectStoryboard


final class ProfileAssembly: Assembly {
    
    func assemble(container: Container) {
        assembleProfile(container)
    }
        
    private func assembleProfile(_ container: Container) {
        assembleViewModels(container)
        assembleViewControllers(container)
    }
    
    private func assembleViewModels(_ container: Container){
        container.register(ProfileViewModel.self){r in
            let dataProvider = r.resolve(DataProvider.self)!
            let auth = r.resolve(AuthenticationProvider.self)!
            return ProfileViewModel(dataProvider: dataProvider, auth: auth)
        }
    }
    
    private func assembleViewControllers(_ container: Container){
        container.register(ProfileViewController.self) { (r: Resolver, delegate: ProfileViewControllerDelegate?) in
            let viewModel = r.resolve(ProfileViewModel.self)!
            return ProfileViewController(viewModel: viewModel, delegate: delegate)
        }
    }
}
