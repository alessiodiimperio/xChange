//
//  ChatProvider.swift
//  xChange
//
//  Created by Alessio on 2021-02-04.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChatProvider {
    func contactSeller(about xChange: XChange, completion: @escaping (String) -> Void)
    func getChat() -> Driver<Chat?>
    func getChats() -> Driver<[Chat]>
    func send(_ message: ChatMessage, to chat: Chat?)
    func setAsRead(_ chat: Chat)
    func remove(_ chat: Chat)
    func subscribeToChat(with chatId: String)
    func unsubscribeToChat()
}
