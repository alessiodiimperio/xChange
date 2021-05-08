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
    private let chatId: String
    private(set) var currentUserId: String?
    
    struct Input {
        let sendButtonTrigger: Driver<Void>
        let textInputTrigger: Driver<String?>
    }
    
    struct Output {
        let onSendButtonTapped: Driver<Void>
        let onTextInput: Driver<String?>
        let onMessages: Driver<[ChatMessage]>
        let onDismiss: Driver<Bool>
    }
    
    init(chatId: String, chatProvider: ChatProvider, authProvider: AuthenticationProvider) {
        self.chatProvider =  chatProvider
        self.authProvider = authProvider
        self.currentUserId = authProvider.currentUserID()
        self.chatId = chatId
    }
    
    func subScribeToChat() {
        chatProvider.subscribeToChat(with: chatId)
    }
    
    func unSubscribeToChat() {
        chatProvider.unsubscribeToChat()
    }
    
    func transform(_ input: Input) -> Output {
        Output(onSendButtonTapped: sendButtonTappedAsDriver(input),
               onTextInput: input.textInputTrigger.asDriver(),
               onMessages: chatMessagesAsDriver(),
               onDismiss: onDismissAsDriver()
        )
    }
    
    private func sendButtonTappedAsDriver(_ input: Input) -> Driver<Void> {
        input.sendButtonTrigger.withLatestFrom(input.textInputTrigger).map { [weak self] textInput in
            guard let message = textInput,
                  !message.isEmpty,
                  let currentUser = self?.authProvider.currentUser.value,
                  let userId = currentUser.id,
                  let chat = self?.chatRelay.value else { return }
            let chatMessage = ChatMessage(timestamp: Date(),
                                          senderId: userId,
                                          senderName: currentUser.username,
                                          message: message)
            
            self?.chatProvider.send(chatMessage, to: chat)
            return
        }
    }
    
    private func chatMessagesAsDriver() -> Driver<[ChatMessage]> {
        chatProvider.getChat()
            .compactMap { $0 }
            .map { [weak self] chat in
                self?.chatRelay.accept(chat)
                self?.chatProvider.setAsRead(chat)
                return chat.messages.sorted { (firstMessage, secondMessage) -> Bool in
                    firstMessage.timestamp > secondMessage.timestamp
                }
            }
    }
    
    private func onDismissAsDriver() -> Driver<Bool> {
        chatProvider.getChat().map { chat -> Bool in
            guard let chat = chat else { return false }
            return chat.available
        }
    }
}
