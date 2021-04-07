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
    private var favoriteProvider: FavoritesProvider

    private let xChange: BehaviorRelay<XChange>
    
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
        let onFavButtonClicked: Driver<Void>
        let onChatButtonClicked: Driver<XChange>
    }
    
    init(_ xChange: XChange,
         auth: AuthenticationProvider,
         favoriteProvider: FavoritesProvider) {
        self.xChange = BehaviorRelay<XChange>(value: xChange)
        self.authProvider = auth
        self.favoriteProvider = favoriteProvider
    }
    
    func transform(_ input: Input) -> Output {
        Output(onImage: imageUrlAsDriver(),
               onTitle: Driver.just(xChange.value.title),
               onPrice: priceLabelAsDriver(),
               onDescription: Driver.just(xChange.value.description),
               onDate: dateLabelAsDriver(),
               onAuthor: authorLabelAsDriver(),
               onFavButtonClicked: onFavoriteButtonTappedAsDriver(input),
               onChatButtonClicked: onChatButtonTappedAsDriver(input))
    }
    
    private func imageUrlAsDriver() -> Driver<URL?> {
        if let link = xChange.value.image,
           let url = URL(string: link) {
            return Driver.just(url)
        }
        return Driver.just(nil)
    }
    
    private func dateLabelAsDriver() -> Driver<String> {
        Driver.just(DateFormat.mediumDateLabel(for: xChange.value.timestamp))
    }
    
    private func priceLabelAsDriver() -> Driver<String> {
        Driver.just(TextFormatter.formatForPrice(xChange.value.price))
    }
    
    private func authorLabelAsDriver() -> Driver<String> {
        let authorLabel = BehaviorSubject(value: "")
        
        authProvider.getUser(for: xChange.value.author) { user in
            if let user = user {
                authorLabel.onNext(user.username)
            }
        }
        
        return authorLabel.asDriver(onErrorJustReturn: "")
    }
    
    private func onFavoriteButtonTappedAsDriver(_ input: Input) -> Driver<Void> {
        input.favButtonTrigger
            .withLatestFrom(xChange.asDriver())
            .map { [weak self] xChange -> Void in
                self?.favoriteProvider.favor(xChange)
            }
    }
    
    private func onChatButtonTappedAsDriver(_ input: Input) -> Driver<XChange> {
        input.chatButtonTrigger.withLatestFrom(xChange.asDriver())
    }
}
