//
//  Storyboarded.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import UIKit
import SwinjectStoryboard

protocol Storyboarded {
    static func instatiate(from storyboard:String) -> Self
}

extension Storyboarded where Self:UIViewController {
    static func instatiate(from storyboard:String) -> Self {
        let id = String(describing: self)
        let storyboard = SwinjectStoryboard.create(name: storyboard, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
extension Storyboarded where Self:TabBarController {
    static func instatiate(from storyboard:String) -> Self {
        let id = String(describing: self)
        let storyboard = SwinjectStoryboard.create(name: storyboard, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
