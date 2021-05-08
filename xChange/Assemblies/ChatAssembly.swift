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
        assembleViews(container)
        assembleViewModels(container)
        assembleViewControllers(container)
    }
    
    private func assembleViews(_ container: Container) {
        container.register(ChatView.self) { _ in
            ChatView()
        }
        
        container.register(DirectChatView.self) { _ in
            DirectChatView()
        }
    }
    
    private func assembleViewModels(_ container: Container){
        container.register(ChatViewModel.self){r in
            let chatProvider = r.resolve(ChatProvider.self)!
            let authProvider = r.resolve(AuthenticationProvider.self)!
            return ChatViewModel(chatProvider: chatProvider,
                                 authProvider: authProvider)
        }
        
        container.register(DirectChatViewModel.self) { (r, chatId: String) in
            let chatProvider = r.resolve(ChatProvider.self)!
            let authProvider = r.resolve(AuthenticationProvider.self)!
            
            return DirectChatViewModel(chatId: chatId,
                                       chatProvider: chatProvider,
                                       authProvider: authProvider)
        }
    }
    
    private func assembleViewControllers(_ container: Container){
        container.register(ChatViewController.self) { (r, delegate: ChatViewControllerDelegate?) in
            let view = r.resolve(ChatView.self)!
            let viewModel = r.resolve(ChatViewModel.self)!
            
            return ChatViewController(view: view, viewModel: viewModel, delegate: delegate)
        }
        
        container.register(DirectChatViewController.self) { (r, chatId: String, delegate: DirectChatViewControllerDelegate?) in
            let view = r.resolve(DirectChatView.self)!
            let viewModel = r.resolve(DirectChatViewModel.self, argument: chatId)!
            
            return DirectChatViewController(view: view,
                                            viewModel: viewModel,
                                            delegate: delegate)
        }
    }
}
