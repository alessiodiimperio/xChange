//
//  FavoritesProvider.swift
//  xChange
//
//  Created by Alessio on 2021-02-04.
//

import Foundation
protocol FavoritesProvider {
    func getFavorites()
    func addFavorite()
    func removeFavorite()
}
