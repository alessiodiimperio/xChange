//
//  LayoutMargin.swift
//  xChange
//
//  Created by Alessio on 2021-04-05.
//
import SnapKit
import UIKit

enum LayoutMargin: CGFloat {
    case point = 1
    case tinyMargin = 4
    case smallMargin = 8
    case mediumMargin = 12
    case regularMargin = 16
    case largeMargin = 24
    case xlargeMargin = 32
    case hugeMargin = 48
    case giganticMargin = 64
}

extension ConstraintMakerRelatable {
    
    @discardableResult
    func equalTo(_ other: LayoutMargin, _ file: String = #file, _ line: UInt = #line) -> ConstraintMakerEditable {
        return equalTo(other.rawValue)
    }
}

extension ConstraintMakerEditable {
    
    @discardableResult
    func offset(_ amount: LayoutMargin) -> ConstraintMakerEditable {
        return offset(amount.rawValue)
    }
    
    @discardableResult
    func inset(_ amount: LayoutMargin) -> ConstraintMakerEditable {
        return inset(amount.rawValue)
    }
    
    @discardableResult
    func multipliedBy(_ amount: LayoutMargin) -> ConstraintMakerEditable {
        return multipliedBy(amount.rawValue)
    }
    
    @discardableResult
    func dividedBy(_ amount: LayoutMargin) -> ConstraintMakerEditable {
        return dividedBy(amount.rawValue)
    }
}
