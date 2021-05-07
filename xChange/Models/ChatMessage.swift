//
//  ChatMessage.swift
//  xChange
//
//  Created by Alessio on 2021-03-14.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable {
    let timestamp: Date
    let senderId: String
    let senderName: String
    let message: String
}
