//
//  File.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//
import RxSwift
import RxCocoa
import Foundation

class FavoritesViewModel: ViewModelType {
    
    private var favouriteProvider: FavoritesProvider
    
    struct Input {
        let favoredItemTrigger: Driver<IndexPath>
        let unfavorItemTrigger: Driver<IndexPath>
        let selectItemnTrigger: Driver<IndexPath>
    }
    struct Output {
        let onFavourites: Driver<[XChange]>
        let onFavoredItem: Driver<Void>
        let onUnfavouredItem: Driver<Void>
    }
    
    init(favouriteProvider:FavoritesProvider){
        self.favouriteProvider = favouriteProvider
    }
    
    func transform(_ input: Input) -> Output {
        Output(onFavourites: getUserFavouritesAsDriver(),
               onFavoredItem: onFavoredXchangeAsDriver(input),
               onUnfavouredItem: onUnfavoredXchangeAsDriver(input))
    }

    private func getUserFavouritesAsDriver() -> Driver<[XChange]> {
        favouriteProvider.getFavoriteXchanges()
    }
    
    private func onFavoredXchangeAsDriver(_ input: Input) -> Driver<Void> {
        input.favoredItemTrigger.withLatestFrom(favouriteProvider.getFavoriteXchanges()) {[weak self] indexPath, favourites in
            let xChange = favourites[indexPath.row]
            self?.favouriteProvider.favor(xChange)
        }
    }
    
    private func onUnfavoredXchangeAsDriver(_ input: Input) -> Driver<Void> {
        input.unfavorItemTrigger.withLatestFrom(favouriteProvider.getFavoriteXchanges()) {[weak self] indexPath, favourites in
            let xChange = favourites[indexPath.row]
            self?.favouriteProvider.unfavor(xChange)
        }
    }
}
