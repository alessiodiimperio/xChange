//
//  Colors.swift
//  xChange
//
//  Created by Alessio on 2021-05-08.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let rValue = Int(color >> 16) & mask
        let gValue = Int(color >> 8) & mask
        let bValue = Int(color) & mask
        let red = CGFloat(rValue) / 255.0
        let green = CGFloat(gValue) / 255.0
        let blue = CGFloat(bValue) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toHexString() -> String {
        var rValue: CGFloat = 0
        var gValue: CGFloat = 0
        var bValue: CGFloat = 0
        var aValue: CGFloat = 0
        getRed(&rValue, green: &gValue, blue: &bValue, alpha: &aValue)
        let rgb: Int = (Int)(rValue * 255) << 16 | (Int)(gValue * 255) << 8 | (Int)(bValue * 255) << 0
        return String(format: "#%06x", rgb)
    }
}
extension UIColor {
    class var mainNavigationColor: UIColor      { return UIColor(hex: "#799eb2") }
    class var mainClickableTintColor: UIColor   { return .black }
    class var mainActiveTintColor: UIColor      { return UIColor(hex: "#EBD1D3") }
}
