//
//  ChatAssembly.swift
//  xChange
//
//  Created by Alessio on 2021-03-09.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class ChatAssembly: Assembly {
    
    func assemble(container: Container) {
        assembleChat(container)
    }
        
    private func assembleChat(_ container: Container) {
        assembleViewModels(container)
        assembleViewControllers(container)
    }
    
    private func assembleViewModels(_ container: Container){
        container.register(ChatViewModel.self){r in
            let chatProvider = r.resolve(ChatProvider.self)!
            return ChatViewModel(chatProvider: chatProvider)
        }
    }
    
    private func assembleViewControllers(_ container: Container){
        container.register(ChatViewController.self) { r in
            let viewModel = r.resolve(ChatViewModel.self)!
            return ChatViewController(viewModel: viewModel)
        }
    }
}
