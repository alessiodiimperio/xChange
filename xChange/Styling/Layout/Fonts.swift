//
//  Fonts.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

extension UIFont {
    
    class var boldHugeTitle: UIFont             { return boldFontText(ofSize: 40) }
    class var boldSuperBigTitle: UIFont         { return boldFontText(ofSize: 32) }
    class var boldBigTitle: UIFont              { return boldFontText(ofSize: 24) }
    class var boldTitle: UIFont                 { return boldFontText(ofSize: 18) }
    class var boldSubtitle: UIFont              { return boldFontText(ofSize: 16) }
    class var boldText: UIFont                  { return boldFontText(ofSize: 14) }
    class var boldSubtext: UIFont               { return boldFontText(ofSize: 12) }
    
    class var semiboldHugeTitle: UIFont         { return semiBoldFontText(ofSize: 40) }
    class var semiboldSuperBigTitle: UIFont     { return semiBoldFontText(ofSize: 32) }
    class var semiboldBigTitle: UIFont          { return semiBoldFontText(ofSize: 24) }
    class var semiboldTitle: UIFont             { return semiBoldFontText(ofSize: 18) }
    class var semiboldSubtitle: UIFont          { return semiBoldFontText(ofSize: 16) }
    class var semiboldText: UIFont              { return semiBoldFontText(ofSize: 14) }
    class var semiboldSubtext: UIFont           { return semiBoldFontText(ofSize: 12) }
    
    class var regularHugeTitle: UIFont          { return regularFontText(ofSize: 40) }
    class var regularSuperBigTitle: UIFont      { return regularFontText(ofSize: 32) }
    class var regularBigTitle: UIFont           { return regularFontText(ofSize: 24) }
    class var regularTitle: UIFont              { return regularFontText(ofSize: 18) }
    class var regularSubtitle: UIFont           { return regularFontText(ofSize: 16) }
    class var regularText: UIFont               { return regularFontText(ofSize: 14) }
    class var regularSubtext: UIFont            { return regularFontText(ofSize: 12) }
    
}

private extension UIFont {
    
    static private func regularFontText(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static private func boldFontText(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static private func semiBoldFontText(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
}

