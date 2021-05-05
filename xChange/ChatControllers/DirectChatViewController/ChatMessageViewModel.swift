//
//  ChatMessageViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import Foundation

final class ChatMessageViewModel {
    
    let date: String
    let message: String?
    let isBuyer: Bool
    
    init(from message: ChatMessage, _ userId: String?) {
        self.date = DateFormat.longDateLabel(for: message.timestamp)
        self.message = message.message
        
        if message.senderId == userId {
            isBuyer = true
        } else {
            isBuyer = false
        }
    }
}
