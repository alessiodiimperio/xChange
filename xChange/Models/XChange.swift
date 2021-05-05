//
//  XChange.swift
//  xChange
//
//  Created by Alessio on 2021-02-04.
//

import Foundation
import FirebaseFirestoreSwift

struct XChange: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var timestamp: Date?
    let title: String
    let description: String
    let author:String
    var followers: [String]
    let price: String?
    let image: String?
}
