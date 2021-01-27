//
//  Coordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//
import Swinject

protocol Coordinator: AnyObject {
    var container:Container {get}
    var navigationController:UINavigationController {get set}
    var childrenCoordinators:[Coordinator] {get set}
    func start()
}
