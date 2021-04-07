//
//  UIView+Layout.swift
//  xChange
//
//  Created by Alessio on 2021-04-05.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { view in
            addSubview(view)
        }
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { view in
            addSubview(view)
        }
    }
}
