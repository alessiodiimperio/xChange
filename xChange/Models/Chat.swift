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
    let xChange: String
    let members: [String]
    let archivedMembers: [String]
}
