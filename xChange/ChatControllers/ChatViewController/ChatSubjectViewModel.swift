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
    
    init(from chat: Chat) {
        imageLink = chat.image
        title = chat.title
        price = chat.itemPrice
        date = DateFormat.mediumDateLabel(for: chat.timestamp)
    }
}
