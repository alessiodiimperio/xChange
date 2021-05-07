//
//  MainViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//
import Firebase
import Foundation
import RxSwift
import RxCocoa

class MainViewModel: ViewModelType {
    private var dataProvider: DataProvider
    private var favoriteProvider: FavoritesProvider
    
    struct Input {
        let searchTrigger: Driver<String>
        let selectItemTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let onFeed: Driver<[XChange]>
        let onItemSelect: Driver<XChange>
    }
    
    init(dataProvider:DataProvider, favoriteProvider: FavoritesProvider){
        self.dataProvider = dataProvider
        self.favoriteProvider = favoriteProvider
    }
    
    func transform(_ input: Input) -> Output {
        Output(onFeed: onFeedAsDriver(input),
               onItemSelect: itemSelectedAsDriver(input))
    }
    
    private func onFeedAsDriver(_ input: Input) -> Driver<[XChange]> {
        dataProvider.getFeed()
    }
    
    private func itemSelectedAsDriver(_ input: Input) -> Driver<XChange> {
        input.selectItemTrigger.withLatestFrom(dataProvider.getFeed()) { indexPath, xChanges in
            xChanges[indexPath.row]
        }
    }
}
