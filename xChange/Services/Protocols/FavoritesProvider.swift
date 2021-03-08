//
//  FavoritesProvider.swift
//  xChange
//
//  Created by Alessio on 2021-02-04.
//

import Foundation
import RxCocoa

protocol FavoritesProvider {
    func getFavoriteXchanges() -> Driver<[XChange]>
    func favor(_ xchange: XChange)
    func unfavor(_ xchange: XChange)
}
