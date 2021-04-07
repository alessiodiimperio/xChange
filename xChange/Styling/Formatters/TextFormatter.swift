//
//  TextFormatter.swift
//  xChange
//
//  Created by Alessio on 2021-04-06.
//

import Foundation

final class TextFormatter {
    static func formatForPrice(_ price: String?) -> String {
        if let price = price,
           let intPrice = Int(price) {
            return "\(intPrice) kr"
        } else if let price = price {
            return "\(price)"
        } else {
            return ""
        }
    }
}
