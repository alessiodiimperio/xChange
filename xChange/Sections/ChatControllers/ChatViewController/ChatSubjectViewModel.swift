//
//  ChatSubjectViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import Foundation

final class ChatSubjectViewModel {
    
    let imageLink: String
    let title: String
    let price: String
    let date: String
    let available: Bool
    let unread: Bool
    
    init(from chat: Chat, unread: Bool) {
        imageLink = chat.image
        title = chat.title
        price = chat.itemPrice
        date = DateFormat.mediumDateLabel(for: chat.timestamp)
        available = chat.available
        self.unread = unread
    }
}
