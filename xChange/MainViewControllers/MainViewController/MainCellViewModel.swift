//
//  MainCellViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-04-05.
//

import Foundation

class MainCellViewModel {

    let image: URL?
    let title: String
    let price: String
    let description: String
    let date: String
    let author: String
    
    init(from xChange: XChange) {
        func getImageUrl(for link: String?) -> URL? {
            if let link = link {
                return URL(string: link)
            }
            return nil
        }
        
        func getDateLabel(for date: Date?) -> String {
            DateFormat.mediumDateLabel(for: date)
        }
        
        title = xChange.title
        price = xChange.price ?? ""
        description = xChange.description
        author = xChange.author
        image = getImageUrl(for: xChange.image)
        date = getDateLabel(for: xChange.timestamp)
    }
}
