//
//  User.swift
//  xChange
//
//  Created by Alessio on 2021-03-02.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var email: String
}
