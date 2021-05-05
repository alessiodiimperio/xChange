//
//  DirectChatViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-05-03.
//

import Foundation
import RxSwift
import RxCocoa

final class DirectChatViewModel: ViewModelType {

    private let authProvider: AuthenticationProvider
    private let chatProvider: ChatProvider
    private let chatRelay = BehaviorRelay<Chat?>(value: nil)
    private let chatMessagesRelay = BehaviorRelay<[ChatMessage]>(value: [])
    
    private(set) var currentUserId: String?
    
    struct Input {
        let sendButtonTrigger: Driver<Void>
        let textInputTrigger: Driver<String?>
    }
    
    struct Output {
        let onSendButtonTapped: Driver<Void>
        let onTextInput: Driver<String?>
        let onMessages: Driver<[ChatMessage]>
    }
    
    init(chatId: String, chatProvider: ChatProvider, authProvider: AuthenticationProvider) {
        self.chatProvider =  chatProvider
        self.authProvider = authProvider
        
        self.currentUserId = authProvider.currentUserID()
        
        chatProvider.getChat(with: chatId) { [weak self] chat in
            if let chat = chat,
               let self = self {
                self.chatRelay.accept(chat)
                self.chatProvider.subscribeToDirectMessages(for: chat) { [weak self] messages in
                    self?.chatMessagesRelay.accept(messages)
                }
            }
        }
    }
    
    deinit {
        guard let chat = chatRelay.value else { return }
        chatProvider.unsubscribeToDirectMessages(for: chat)
    }
    
    func transform(_ input: Input) -> Output {
        Output(onSendButtonTapped: sendButtonTappedAsDriver(input),
               onTextInput: input.textInputTrigger.asDriver(),
               onMessages: chatMessagesAsDriver()
        )
    }
    
    private func sendButtonTappedAsDriver(_ input: Input) -> Driver<Void> {
        input.sendButtonTrigger.withLatestFrom(input.textInputTrigger).map { [weak self] textInput in
            guard let message = textInput,
                  !message.isEmpty,
                  let currentUser = self?.authProvider.currentUser.value,
                  let userId = currentUser.id,
                  let chat = self?.chatRelay.value else { return }
            
            let chatMessage = ChatMessage(senderId: userId,
                                          senderName: currentUser.username,
                                          message: message)
            
            self?.chatProvider.send(chatMessage, to: chat)
            return
        }
    }
    
    private func chatMessagesAsDriver() -> Driver<[ChatMessage]> {
        chatMessagesRelay
            .compactMap { $0 }
            .map({ messages -> [ChatMessage] in
                messages.sorted { (prevMessage, nextMessage) -> Bool in
                    guard let firstTimeStamp = prevMessage.timestamp,
                          let secondTimeStamp = nextMessage.timestamp else { return false }
                    return firstTimeStamp > secondTimeStamp
                }
            }).asDriver(onErrorJustReturn: [])
    }
}
