//
//  UILabel+.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/11/24.
//

import UIKit

extension UILabel {
    func addBottomBorderWithAttributedString(underlineColor: UIColor = .black, textColor: UIColor? = nil) {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        var attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: underlineColor
        ]
        
        if let textColor = textColor {
            attributes[.foregroundColor] = textColor
        }
        
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}
