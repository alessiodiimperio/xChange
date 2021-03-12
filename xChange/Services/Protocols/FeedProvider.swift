//
//  FeedProvider.swift
//  xChange
//
//  Created by Alessio on 2021-03-07.
//

import Foundation
import RxCocoa

protocol FeedProvider {
    func getFeed() -> Driver<[XChange]>
}
