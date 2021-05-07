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
        let favouriteItemSelectedTrigger: Driver<IndexPath>
        let favouriteToggleTrigger: Driver<IndexPath>
    }
    struct Output {
        let onFavouriteSelected: Driver<XChange>
        let onFavourites: Driver<[XChange]>
        let onFavoriteToggle: Driver<Void>
    }
    
    init(favouriteProvider:FavoritesProvider){
        self.favouriteProvider = favouriteProvider
    }
    
    func transform(_ input: Input) -> Output {
        Output(onFavouriteSelected: onFavouriteSelectedAsDriver(input),
               onFavourites: getUserFavouritesAsDriver(),
               onFavoriteToggle: onFavoriteToggledAsDriver(input))
    }

    private func onFavouriteSelectedAsDriver(_ input: Input) -> Driver<XChange> {
        input.favouriteItemSelectedTrigger.withLatestFrom(favouriteProvider.getFavoriteXchanges()) { indexPath, xChanges in
            xChanges[indexPath.row]
        }
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
