//
//  Storyboarded.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import UIKit
import SwinjectStoryboard

enum StoryboardType:String {
    case rootStoryboard = "Root"
    case mainStoryboard = "Main"
    case favoritesStoryboard = "Favorites"
    case addXChangeStoryboard = "AddXChange"
    case chatStoryboard = "Chat"
    case profileStoryboard = "Profile"
}

protocol Storyboarded {
    static func instatiate(from storyboard:StoryboardType) -> Self
}

extension Storyboarded where Self:UIViewController {
    static func instatiate(from storyboard:StoryboardType) -> Self {
        let id = String(describing: self)
        let storyboard = SwinjectStoryboard.create(name: storyboard.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
extension Storyboarded where Self:TabBarController {
    static func instatiate(from storyboard:StoryboardType) -> Self {
        let id = String(describing: self)
        let storyboard = SwinjectStoryboard.create(name: storyboard.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
