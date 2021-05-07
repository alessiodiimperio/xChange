//
//  Chat.swift
//  xChange
//
//  Created by Alessio on 2021-03-14.
//

import Foundation
import FirebaseFirestoreSwift

struct Chat: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var timestamp: Date?
    let xChangeId: String
    let title: String
    let image: String
    let itemPrice: String
    let seller: String
    let sellerName: String
    let buyer: String
    var chatters: [String]
    var hasNewMessage: [String]
    let messages: [ChatMessage]
    var available: Bool
}
