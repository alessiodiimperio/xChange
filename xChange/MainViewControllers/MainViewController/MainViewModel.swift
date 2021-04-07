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
    private var feedProvider: FeedProvider
    private var favoriteProvider: FavoritesProvider
    
    struct Input {
        let searchTrigger: Driver<String>
        let selectItemTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let onFeed: Driver<[XChange]>
        let onItemSelect: Driver<XChange>
    }
    
    init(feedProvider:FeedProvider, favoriteProvider: FavoritesProvider){
        self.feedProvider = feedProvider
        self.favoriteProvider = favoriteProvider
    }
    
    func transform(_ input: Input) -> Output {
        Output(onFeed: onFeedAsDriver(input),
               onItemSelect: itemSelectedAsDriver(input))
    }
    
    private func onFeedAsDriver(_ input: Input) -> Driver<[XChange]> {
        feedProvider.getFeed()
    }
    
    private func itemSelectedAsDriver(_ input: Input) -> Driver<XChange> {
        input.selectItemTrigger.withLatestFrom(feedProvider.getFeed()) { indexPath, xChanges in
            xChanges[indexPath.row]
        }
    }
}
