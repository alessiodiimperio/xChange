//
//  AppAssembler.swift
//  xChange
//
//  Created by Alessio on 2021-03-08.
//

import Foundation
import Swinject

class AppAssembler {
    
    static let shared: Assembler = {
        return assembler()
    }()
    
    class func assembler() -> Assembler {
        return Assembler([
            CoordinatorAssembly(),
            RootAssembly(),
            ServiceAssembly(),
            MainAssembly(),
            FavouritesAssembly(),
            AddXChangeAssembly(),
            ChatAssembly(),
            ProfileAssembly()
        ])
    }
}
