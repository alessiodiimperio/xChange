//
//  MainDetailViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-03-30.
//
import RxSwift
import RxCocoa
import Foundation

class DetailViewModel: ViewModelType {
    private let authProvider: AuthenticationProvider
    private let favoriteProvider: FavoritesProvider
    private let dataProvider: DataProvider
    private let chatProvider: ChatProvider
    
    private let xChangeDetail: Driver<XChange?>
    
    struct Input {
        let favButtonTrigger: Driver<Void>
        let chatButtonTrigger: Driver<Void>
        let soldButtonTrigger: Driver<Void>
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
        let onContactSellerClicked: Driver<String?>
        let onSoldButtonClicked: Driver<Void>
        let onIsUserXchange: Driver<Bool>
    }
    
    init(_ xChange: XChange,
         authProvider: AuthenticationProvider,
         favoriteProvider: FavoritesProvider,
         dataProvider: DataProvider,
         chatProvider: ChatProvider) {
        
        self.dataProvider = dataProvider
        self.authProvider = authProvider
        self.favoriteProvider = favoriteProvider
        self.chatProvider = chatProvider
        
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
               onContactSellerClicked: onChatButtonTappedAsDriver(input),
               onSoldButtonClicked: onSoldButtonTappedAsDriver(input),
               onIsUserXchange: onHideFunctionButtons()
        )
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
        return xChangeDetail.compactMap { $0 }
            .map { xChange in
                xChange.authorName
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
                if let xChange = xChange {
                    self?.favoriteProvider.toggleFavorite(xChange)
                }
            }
    }
    
    private func onHideFunctionButtons() -> Driver<Bool> {
        xChangeDetail.map { [weak self] xChange -> Bool in
            guard let xChange = xChange,
                  let userId = self?.authProvider.currentUserID() else { return true }
            
            return xChange.author == userId
        }
    }
    
    private func onChatButtonTappedAsDriver(_ input: Input) -> Driver<String?> {
        input.chatButtonTrigger.withLatestFrom(xChangeDetail)
            .compactMap { $0 }
            .map { xChange -> Observable<String?> in
                return .create { observer -> Disposable in
                    self.chatProvider.contactSeller(about: xChange) { chatId in
                        observer.onNext(chatId)
                    }
                    return Disposables.create { }
                }
            }.flatMap { $0.asDriver(onErrorJustReturn: nil) }
    }
    
    private func onSoldButtonTappedAsDriver(_ input: Input) -> Driver<Void> {
        input.soldButtonTrigger.withLatestFrom(xChangeDetail)
            .map { [weak self] xChange in
                guard let xChange = xChange else { return }
                self?.dataProvider.makeUnavailable(xChange)
            }
    }
}
