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
        let deleteItemTrigger: Driver<IndexPath>
        let signOutTrigger:Driver<Void>
    }
    struct Output {
        let onsignOutTapped:Driver<Void>
        let onUserXChanges:Driver<[XChange]>
        let onDeleteItem: Driver<Void>
    }
    
    init(dataProvider:DataProvider){
        self.dataProvider = dataProvider
    }
    
    func transform(_ input: Input) -> Output {
        
        Output(onsignOutTapped: input.signOutTrigger.asDriver(),
               onUserXChanges: getUserXChangesAsDriver(),
               onDeleteItem: onDeleteXchangeAsDriver(input)
        )
    }

    private func signOutTriggerAsDriver(_ input: Input) -> Driver<Void>{
        input.signOutTrigger.asDriver()
    }
    
    private func getUserXChangesAsDriver() -> Driver<[XChange]>{
        dataProvider.getUsersXchanges()
    }
    
    private func onDeleteXchangeAsDriver(_ input: Input) -> Driver<Void> {
        input.deleteItemTrigger.withLatestFrom(dataProvider.getUsersXchanges()) {[weak self] indexPath, xChanges in
            let xChange = xChanges[indexPath.row]
            self?.dataProvider.delete(xChange)
        }
    }
}
