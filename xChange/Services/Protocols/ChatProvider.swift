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
    func getConversations() -> Driver<[Chat]>
    func deleteConversation()
    func sendMessage()
}
