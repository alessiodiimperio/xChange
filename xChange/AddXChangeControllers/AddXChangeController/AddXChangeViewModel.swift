//
//  AddXChangeViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import Foundation
import RxSwift
import RxCocoa

class AddXChangeViewModel: ViewModelType, ViewModelWithLoadingState {
    let state = BehaviorRelay<LoadingState>(value: .initial)
    
    var authenticationService: AuthenticationProvider
    var xChangeService: DataProvider
    
    private let image = BehaviorRelay<UIImage>(value: UIImageView().placeHolderPhoto())
    private let placeholderUpdated = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let titleTextfieldTrigger: Driver<String?>
        let descriptionTextViewTrigger: Driver<String?>
        let createButtonTrigger: Driver<Void>
        let imageViewTappedTrigger: Driver<Void>
        let priceTextFieldTrigger: Driver<String?>
    }
    
    struct Output {
        let onImageViewImage: Driver<UIImage>
        let onTitleTextFieldText: Driver<String?>
        let onDescriptionTextViewText: Driver<String?>
        let onDescriptionPlaceholder: Driver<Bool>
        let onCreateButtonTapped: Driver<Void>
        let onCreateButtonEnabled: Driver<Bool>
        let onImageViewTapped: Driver<Void>
        let onPlaceHolderUpdated: Driver<Bool>
    }
    
    init(xChangeService: DataProvider, authenticationService: AuthenticationProvider){
        self.xChangeService = xChangeService
        self.authenticationService = authenticationService
    }
    
    func transform(_ input: Input) -> Output{
        Output(onImageViewImage: image.asDriver(),
                      onTitleTextFieldText: input.titleTextfieldTrigger.asDriver(),
                      onDescriptionTextViewText: input.descriptionTextViewTrigger.asDriver(),
                      onDescriptionPlaceholder: placeholderHiddenAsDriver(descriptionTextViewTextTrigger: input.descriptionTextViewTrigger),
                      onCreateButtonTapped: createButtonTappedAsDriver(input),
                      onCreateButtonEnabled: createButtonEnabledAsDriver(input),
                      onImageViewTapped: input.imageViewTappedTrigger.asDriver(),
                      onPlaceHolderUpdated: placeholderUpdated.asDriver()
        )
    }
    
    func setImageViewImage(to image: UIImage?) {
        guard let image = image else { return }
        self.image.accept(image)
        placeholderUpdated.accept(true)
    }
    
    private func placeholderHiddenAsDriver(descriptionTextViewTextTrigger: Driver<String?>) -> Driver<Bool> {
        descriptionTextViewTextTrigger.map { text -> Bool in
            guard let text = text else { return false }
            return !text.isEmpty
        }
    }
    
    private func createButtonEnabledAsDriver(_ input: Input) -> Driver<Bool> {
        Driver.combineLatest(input.titleTextfieldTrigger.asDriver(),
                             input.descriptionTextViewTrigger.asDriver(),
                             input.priceTextFieldTrigger.asDriver()).map { title, description, price -> Bool in
                                guard let title = title,
                                      let description = description,
                                      let price = price else { return false }
                                return !title.isEmpty && !description.isEmpty && !price.isEmpty
                             }
    }
    
    private func createXChangeDriver(from input: Input) -> Driver<XChange?> {
        Driver.combineLatest(input.titleTextfieldTrigger,
                             input.descriptionTextViewTrigger,
                             input.priceTextFieldTrigger).map {[weak self] (title,
                                                                           description,
                                                                           price) -> XChange? in
                                guard let title = title,
                                      let description = description,
                                      let price = price,
                                      let currentUser = self?.authenticationService.currentUser.value,
                                      let userId = currentUser.id else { return nil }
                                
                                
                                return XChange(title: title,
                                               description: description,
                                               author: userId,
                                               authorName: currentUser.username,
                                               followers: [],
                                               price: price,
                                               image: nil,
                                               available: true)
                                
                             }
    }
    
    private func createButtonTappedAsDriver(_ input: Input) -> Driver<Void> {
        input.createButtonTrigger.withLatestFrom(createXChangeDriver(from: input))
            .compactMap { $0 }
            .map { [weak self] xChange -> Void in
                
                self?.setLoadingState()
                
                guard let image = self?.image.value,
                      image != UIImageView().placeHolderPhoto() else {
                    self?.xChangeService.add(xChange) {
                        self?.setSuccessState()
                    }
                    return
                }
                self?.xChangeService.uploadImage(image) { imageLink in
                    self?.xChangeService.add(XChange(title: xChange.title,
                                                     description: xChange.description,
                                                     author: xChange.author,
                                                     authorName: self?.authenticationService.currentUser.value?.username ?? "",
                                                     followers: xChange.followers,
                                                     price: xChange.price,
                                                     image: imageLink,
                                                     available: true)) {
                        self?.setSuccessState()
                    }
                }
            }
    }
}
