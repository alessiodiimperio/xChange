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
    
    //Services
    private var auth: AuthenticationProvider
    private var dataProvider: DataProvider
    
    //Static vars
    let contentPlaceholderTitle = "This is where will be able to view/edit your listings."
    let contentPlaceholderImage = UIImage(systemName: "rectangle.stack.fill.badge.person.crop")
    let signOutButtonTitle = "Sign Out"
    
    //Reactive vars
    struct Input {
        let itemSelectedTrigger: Driver<IndexPath>
        let signOutTrigger:Driver<Void>
    }
    struct Output {
        let onsignOutTapped:Driver<Void>
        let onUserXChanges:Driver<[XChange]>
        let onItemSelected: Driver<XChange>
        let onUser: Driver<User?>
    }
    
    init(dataProvider:DataProvider, auth: AuthenticationProvider){
        self.dataProvider = dataProvider
        self.auth = auth
    }
    
    func transform(_ input: Input) -> Output {
        Output(onsignOutTapped: input.signOutTrigger.asDriver(),
               onUserXChanges: getUserXChangesAsDriver(),
               onItemSelected: onItemSelectedAsDriver(input),
               onUser: userAsDriver()
        )
    }

    private func signOutTriggerAsDriver(_ input: Input) -> Driver<Void>{
        input.signOutTrigger.asDriver()
    }
    
    private func getUserXChangesAsDriver() -> Driver<[XChange]>{
        dataProvider.getUsersXchanges()
    }
    
    private func onItemSelectedAsDriver(_ input: Input) -> Driver<XChange> {
        input.itemSelectedTrigger.withLatestFrom(dataProvider.getUsersXchanges()) { indexPath, xChanges in
            xChanges[indexPath.row]
        }
    }
    
    private func userAsDriver() -> Driver<User?> {
        auth.currentUser
            .asDriver()
    }
}
