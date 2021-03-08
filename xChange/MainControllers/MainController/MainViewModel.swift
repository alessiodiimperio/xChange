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
    
    struct Input {
        let searchTrigger: Driver<String>
        let selectItemTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let onFeed: Driver<[XChange]>
        let onItemSelect: Driver<XChange>
    }
    
    init(feedProvider:FeedProvider){
        self.feedProvider = feedProvider
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
            let xChange = xChanges[indexPath.row]
            print(xChange.title)
            return XChange(id: "test", timestamp: Date(), title: "title", description: "description", author: "author", followers: [])
        }
    }
}
