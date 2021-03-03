//
//  AddXChangeViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import Foundation
import RxSwift
import RxCocoa

class AddXChangeViewModel {
    var authenticationService: AuthenticationProvider
    var xChangeService: DataProvider
    
    struct Input {
        let titleTextfieldTrigger: Driver<String?>
        let descriptionTextViewTrigger: Driver<String?>
        let createButtonTrigger: Driver<Void>
    }
    struct Output {
        let onImageViewImage: Driver<UIImage>
        let onTitleTextFieldText: Driver<String?>
        let onDescriptionTextViewText: Driver<String?>
        let onDescriptionPlaceholder: Driver<Bool>
        let onCreateButtonTapped: Driver<Void>
        let onCreateButtonEnabled: Driver<Bool>
    }
    
    init(xChangeService: DataProvider, authenticationService: AuthenticationProvider){
        self.xChangeService = xChangeService
        self.authenticationService = authenticationService
    }
    
    func transform(_ input: Input) -> Output{
                Output(onImageViewImage: imageViewImageAsDriver(),
                      onTitleTextFieldText: input.titleTextfieldTrigger.asDriver(),
                      onDescriptionTextViewText: input.descriptionTextViewTrigger.asDriver(),
                      onDescriptionPlaceholder: placeholderHiddenAsDriver(descriptionTextViewTextTrigger: input.descriptionTextViewTrigger),
                      onCreateButtonTapped: createButtonTappedAsDriver(input),
                      onCreateButtonEnabled: createButtonEnabledAsDriver(input)
        )
    }
    
    private func imageViewImageAsDriver() -> Driver<UIImage> {
        Driver.just(UIImage(named: "banner") ?? UIImage())
    }
    
    private func xChangeStreamAsDriver(titleTextfieldTrigger: Driver<String?>, descriptionTextViewTrigger: Driver<String?>) -> Driver<XChange?>{
        Driver.combineLatest(titleTextfieldTrigger, descriptionTextViewTrigger).map {[weak self] (title, description) -> XChange? in
            guard let title = title,
                  let description = description,
                  let userID = self?.authenticationService.currentUserID() else {
                return nil
            }
            return XChange(title: title, description: description, author: userID)
        }
    }

    private func placeholderHiddenAsDriver(descriptionTextViewTextTrigger: Driver<String?>) -> Driver<Bool> {
        descriptionTextViewTextTrigger.map { text -> Bool in
            guard let text = text else { return false }
            return !text.isEmpty
        }
    }
    
    private func createButtonEnabledAsDriver(_ input: Input) -> Driver<Bool> {
        Driver.combineLatest(input.titleTextfieldTrigger.asDriver(), input.descriptionTextViewTrigger.asDriver()).map { title, description -> Bool in
            guard let title = title,
                  let description = description else { return false }
            return !title.isEmpty && !description.isEmpty
        }
    }
    
    private func createButtonTappedAsDriver(_ input: Input) -> Driver<Void> {
        let xChangeStream = xChangeStreamAsDriver(titleTextfieldTrigger: input.titleTextfieldTrigger,
                                                  descriptionTextViewTrigger: input.descriptionTextViewTrigger
        )
       
        return input.createButtonTrigger.withLatestFrom(xChangeStream).map {[weak self] xChange -> Void in
            guard let xChange = xChange else { return ()}
            self?.createXchange(with: xChange)
            return ()
        }
    }
    
    private func createXchange(with xChange: XChange?){
        guard let xChange = xChange else { return }
        xChangeService.add(xChange)
    }
}
