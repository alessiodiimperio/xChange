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
    func createChat(about xChange: XChange, with chatId: String)
    func getChats() -> Driver<[Chat]>
    func getChat(with chatId: String, completion: @escaping (Chat?) -> Void)
    func send(_ message: ChatMessage, to chat: Chat?)
    func subscribeToDirectMessages(for chat: Chat, completion: @escaping ([ChatMessage]) -> Void)
    func unsubscribeToDirectMessages(for chat: Chat)
}
