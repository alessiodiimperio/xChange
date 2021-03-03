//
//  ProfileViewModel.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import RxSwift
import RxCocoa
import Foundation

class ProfileViewModel: ViewModelType {
    
    private var dataProvider: DataProvider
    
    struct Input {
        let signOutTrigger:Driver<Void>
    }
    struct Output {
        let onsignOutTapped:Driver<Void>
        let onUserXChanges:Driver<[XChange]>
    }
    
    init(dataProvider:DataProvider){
        self.dataProvider = dataProvider
    }
    
    func transform(_ input: Input) -> Output {
        Output(onsignOutTapped: input.signOutTrigger.asDriver(),
               onUserXChanges: getUserXChangesAsDriver()
        )
    }

    private func signOutTriggerAsDriver(_ input: Input) -> Driver<Void>{
        input.signOutTrigger.asDriver()
    }
    
    private func getUserXChangesAsDriver() -> Driver<[XChange]>{
        dataProvider.getLatestXChanges().asDriver(onErrorJustReturn: [XChange(id: "lkj", timestamp: nil, title: "test", description: "error", author: "noone")])
    }
}
