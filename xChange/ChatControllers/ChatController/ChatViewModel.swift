//
//  ChatViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import Foundation
import RxSwift
import RxCocoa

class ChatViewModel {
    
    let chatProvider: ChatProvider
    
    struct Input {
    }
    
    struct Output {
        let chats: Driver<[Chat]>
    }
    
    init(chatProvider: ChatProvider) {
        self.chatProvider = chatProvider
    }
    
    func transform(_ Input: Input) -> Output {
        Output(chats: Driver.just([Chat]()))
    }
}
