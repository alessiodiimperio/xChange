//
//  ChatMessageViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import Foundation

final class ChatMessageViewModel {
    let date: String
    let userMessage: String?
    let peerMessage: String?
    
    init(from message: ChatMessage) {
        self.date = DateFormat.mediumDateLabel(for: message.timestamp)
        self.userMessage = message.message
        self.peerMessage = message.message
    }
}
