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
    func removeConversation(_ id: String)
    func sendMessage(to usaerId: String, about xChange: String)
}
