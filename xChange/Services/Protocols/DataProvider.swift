//
//  XChangeDataService.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//
import Firebase
import Foundation
import RxSwift
import RxCocoa

protocol DataProvider{
    func getUsersXchanges() -> Driver<[XChange]>
    func subscribeToChanges(in xChange: XChange) -> Driver<Void>
    func unsubscribeToChanges(in xChange: XChange)
    func add(_ xChange: XChange)
    func delete(_ xChange: XChange)
    func uploadImage(_ image: UIImage, _ completion: @escaping (String?) -> Void)
}
