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
    let authProvider: AuthenticationProvider
    let chatProvider: ChatProvider
    
    struct Input {
        let itemSelectedTrigger: Driver<IndexPath>
        let itemDeletedTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let onChats: Driver<[Chat]>
        let onItemSelected: Driver<String?>
        let onItemDeleted: Driver<Void>
        let onUnreadMessage: Driver<Int?>
    }
    
    init(chatProvider: ChatProvider, authProvider: AuthenticationProvider) {
        self.chatProvider = chatProvider
        self.authProvider = authProvider
    }
    
    func transform(_ input: Input) -> Output {
        Output(onChats: chatProvider.getChats(),
               onItemSelected: itemSelectedAsDriver(input),
               onItemDeleted: onItemDeletedAsDriver(input),
               onUnreadMessage: onUnreadMessagesAsDriver(input)
        )
    }
    
    private func itemSelectedAsDriver(_ input: Input) -> Driver<String?> {
        input.itemSelectedTrigger.withLatestFrom(Driver.combineLatest(
            input.itemSelectedTrigger,
            chatProvider.getChats())
        ).map { (indexPath, chats) -> String? in
            
            guard chats.count > 0,
                  indexPath.row <= chats.count - 1,
                  chats[indexPath.row].available != false else { return nil }
            return chats[indexPath.row].id
        }.asDriver(onErrorJustReturn: nil)
    }
    
    private func onItemDeletedAsDriver(_ input: Input) -> Driver<Void> {
        input.itemDeletedTrigger.withLatestFrom(Driver.combineLatest(
            input.itemDeletedTrigger,
            chatProvider.getChats())
        ).map { [weak self] indexPath, chats in
            
            guard chats.count > 0,
                  indexPath.row <= chats.count - 1  else { return }
            self?.chatProvider.remove(chats[indexPath.row])
        }.asDriver(onErrorJustReturn: ())
    }
    
    private func onUnreadMessagesAsDriver(_ input: Input) -> Driver<Int?> {
        chatProvider.getChats().map { [weak self] chats -> Int? in
            guard let userId = self?.authProvider.currentUserID() else { return nil }
            var unreadMessages = 0
            chats.forEach { chat in
                if chat.hasNewMessage.contains(userId) {
                    unreadMessages += 1
                }
            }
            print(unreadMessages)
            return unreadMessages
        }
    }
}
