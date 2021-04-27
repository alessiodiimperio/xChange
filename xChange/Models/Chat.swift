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
    let recieverId: String
    let senderId: String
    let active: Bool
}
