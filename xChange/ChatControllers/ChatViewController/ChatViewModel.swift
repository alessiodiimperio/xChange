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
        let itemSelectedTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let onChats: Driver<[Chat]>
        let onItemSelected: Driver<String?>
    }
    
    init(chatProvider: ChatProvider) {
        self.chatProvider = chatProvider
    }
    
    func transform(_ Input: Input) -> Output {
        Output(onChats: chatProvider.getChats(),
               onItemSelected: itemSelectedAsDriver(Input)
        )
    }
    
    private func itemSelectedAsDriver(_ input: Input) -> Driver<String?> {
        Observable.combineLatest(
            input.itemSelectedTrigger.asObservable(),
            chatProvider.getChats().asObservable()
        ).map { (indexPath, chats) -> String? in
            
            guard chats.count - 1 <= indexPath.row else { return nil }
            return chats[indexPath.row].id
        }.asDriver(onErrorJustReturn: nil)
    }
}
