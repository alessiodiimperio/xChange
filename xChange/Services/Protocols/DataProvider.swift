//
//  XChangeDataService.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import Foundation
import RxSwift
protocol DataProvider{
    func getLatestXChanges()->Observable<[XChange]>
    func getUserXChanges()->Observable<[XChange]>
    func add(_ xChange: XChange)
    func delete(_ xChange: XChange)
}
