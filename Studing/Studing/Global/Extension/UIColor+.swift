//
//  UIColor+.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/18/24.
//

import UIKit

extension UIColor {
    func withFigmaStyleAlpha(_ alpha: CGFloat) -> UIColor {
        var red: CGFloat = 196, green: CGFloat = 228, blue: CGFloat = 195, a: CGFloat = 0.3
        getRed(&red, green: &green, blue: &blue, alpha: &a)
        
        // 색상을 밝게 만들면서 알파값 조정
        return UIColor(red: red + (1 - red) * (1 - alpha),
                       green: green + (1 - green) * (1 - alpha),
                       blue: blue + (1 - blue) * (1 - alpha),
                       alpha: 1.0)
    }
}
