//
//  UILabel+Styling.swift
//  xChange
//
//  Created by Alessio on 2021-04-28.
//

import UIKit

extension UILabel {
    
    func setupUI(textColor: UIColor = .black,
                 font: UIFont,
                 adjustsFontSizeToFitWidth: Bool = true,
                 minimumScaleFactor: CGFloat = 0.5,
                 textAlignment: NSTextAlignment = .left) {
        self.font = font
        self.textColor = textColor
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        self.minimumScaleFactor = minimumScaleFactor
        self.textAlignment = textAlignment
    }
    
    func set(lineHeight: CGFloat, lineBreakMode: NSLineBreakMode = .byWordWrapping) {
        guard let text = text else { return }
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = lineBreakMode

        attrString.addAttribute(
            NSAttributedString.Key.font,
            value: font as Any,
            range: NSRange(location: 0, length: attrString.length)
        )

        attrString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attrString.length)
        )

        attributedText = attrString
    }
}
