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
        let favouriteToggleTrigger: Driver<IndexPath>
    }
    struct Output {
        let onFavourites: Driver<[XChange]>
        let onFavoriteToggle: Driver<Void>
    }
    
    init(favouriteProvider:FavoritesProvider){
        self.favouriteProvider = favouriteProvider
    }
    
    func transform(_ input: Input) -> Output {
        Output(onFavourites: getUserFavouritesAsDriver(),
               onFavoriteToggle: onFavoriteToggledAsDriver(input))
    }

    private func getUserFavouritesAsDriver() -> Driver<[XChange]> {
        favouriteProvider.getFavoriteXchanges()
    }
    
    private func onFavoriteToggledAsDriver(_ input: Input) -> Driver<Void> {
        input.favouriteToggleTrigger.withLatestFrom(favouriteProvider.getFavoriteXchanges()) { [weak self] indexPath, favorites in
            let xChange = favorites[indexPath.row]
            self?.favouriteProvider.toggleFavorite(xChange)
        }.asDriver()
    }
}
