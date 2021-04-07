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
    var title: String
    var description: String
    let author:String
    var followers: [String]
    var price: String?
    var image: String?
}
