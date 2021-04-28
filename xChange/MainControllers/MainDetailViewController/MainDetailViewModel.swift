//
//  MainDetailViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-03-30.
//
import RxSwift
import RxCocoa
import Foundation

final class MainDetailViewModel: ViewModelType {
    private let authProvider: AuthenticationProvider
    private let favoriteProvider: FavoritesProvider
    private let dataProvider: DataProvider
    
    private let xChange = BehaviorRelay<XChange?>(value: nil)
    private let xChangeDetail: Driver<XChange?>
    
    struct Input {
        let favButtonTrigger: Driver<Void>
        let chatButtonTrigger: Driver<Void>
    }
    
    struct Output {
        let onImage: Driver<URL?>
        let onTitle: Driver<String>
        let onPrice: Driver<String>
        let onDescription: Driver<String>
        let onDate: Driver<String>
        let onAuthor: Driver<String>
        let onIsFavourite: Driver<Bool>
        let onFavButtonClicked: Driver<Void>
        let onChatButtonClicked: Driver<XChange>
    }
    
    init(_ xChange: XChange,
         authProvider: AuthenticationProvider,
         favoriteProvider: FavoritesProvider,
         dataProvider: DataProvider) {
        
        self.dataProvider = dataProvider
        self.authProvider = authProvider
        self.favoriteProvider = favoriteProvider
        
        self.xChangeDetail = dataProvider.subscribeToChanges(in: xChange)
    }
    
    deinit {
        dataProvider.unsubscribeToChanges()
    }
    
    func transform(_ input: Input) -> Output {
        Output(onImage: imageUrlAsDriver(),
               onTitle: titleLabelAsDriver(),
               onPrice: priceLabelAsDriver(),
               onDescription: descriptionLabelAsDriver(),
               onDate: dateLabelAsDriver(),
               onAuthor: authorLabelAsDriver(),
               onIsFavourite: onIsFavouriteAsDriver(),
               onFavButtonClicked: onFavoriteButtonTappedAsDriver(input),
               onChatButtonClicked: onChatButtonTappedAsDriver(input))
    }
    
    private func titleLabelAsDriver() -> Driver<String> {
        xChangeDetail.compactMap { $0 }
            .map { xChange -> String in
                return xChange.title
            }.asDriver()
    }
    
    private func descriptionLabelAsDriver() -> Driver<String> {
        xChangeDetail.compactMap { $0 }
            .map { xChange -> String in
                return xChange.description
            }.asDriver()
    }
    
    private func imageUrlAsDriver() -> Driver<URL?> {
        xChangeDetail.compactMap { $0 }
            .map { xChange -> URL? in
                if let link = xChange.image,
                   let url = URL(string: link) {
                    return url
                }
                return nil
            }.asDriver()
    }
    
    private func dateLabelAsDriver() -> Driver<String> {
        xChangeDetail.compactMap { $0 }
            .map { xChange -> String in
                DateFormat.mediumDateLabel(for: xChange.timestamp)
            }.asDriver()
    }
    
    private func priceLabelAsDriver() -> Driver<String> {
        xChangeDetail.compactMap { $0 }
            .map { xChange -> String in
                TextFormatter.formatForPrice(xChange.price)
            }
    }
    
    private func authorLabelAsDriver() -> Driver<String> {
        let authorLabel = BehaviorRelay(value: "")
        
        return xChangeDetail.compactMap { $0 }
            .map { [weak self] xChange -> String in
                self?.authProvider.getUser(for: xChange.author) { user in
                    if let user = user {
                        authorLabel.accept(user.username)
                    }
                }
                return authorLabel.value
            }.asDriver()
    }
    
    private func onIsFavouriteAsDriver() -> Driver<Bool> {
        xChangeDetail.compactMap { $0 }
            .map { [weak self] xChange -> Bool in
                guard let userId = self?.authProvider.currentUserID() else { return false }
                return xChange.followers.contains(userId)
            }.asDriver()
    }
    
    private func onFavoriteButtonTappedAsDriver(_ input: Input) -> Driver<Void> {
        input.favButtonTrigger
            .withLatestFrom(xChangeDetail)
            .map { [weak self] xChange -> Void in
                print("fav pressed")
                if let xChange = xChange {
                    self?.favoriteProvider.toggleFavorite(xChange)
                }
            }
    }
    
    private func onChatButtonTappedAsDriver(_ input: Input) -> Driver<XChange> {
        return input.chatButtonTrigger.withLatestFrom(xChangeDetail.compactMap { $0 })
    }
}
