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
            return ProfileViewModel(dataProvider: dataProvider)
        }
    }
    
    private func assembleViewControllers(_ container: Container){
        let profileStoryboard = SwinjectStoryboard.create(name: "Profile", bundle: Bundle.main, container: container)
        
        container.register(ProfileViewController.self) { r in
            let controller = profileStoryboard.instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as! ProfileViewController
            controller.viewModel = r.resolve(ProfileViewModel.self)
            return controller
        }
    }
}
