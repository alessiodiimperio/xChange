//
//  UIViewController+HideKeyboard.swift
//  xChange
//
//  Created by Alessio on 2021-01-28.
//

import UIKit

extension UIViewController {
    internal func hideKeyboardOnTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap);
    }
    @objc private func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
