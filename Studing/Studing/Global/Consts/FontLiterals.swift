//
//  FontLiterals.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/20/24.
//

import UIKit

enum FontName: String {
    case MontserratExtraBold = "Montserrat-ExtraBold"
    case InterRegualr = "Inter-Regular"
    case InterRegualrThin = "Inter-Regular_Thin"
    case InterRegualrExtraLight = "Inter-Regular_ExtraLight"
    case InterRegualrLight = "Inter-Regular_Light"
    case InterRegualrMedium = "Inter-Regular_Medium"
    case InterRegualrSemiBold = "Inter-Regular_SemiBold"
    case InterRegualrBold = "Inter-Regular_Bold"
    case InterRegualrExtraBold = "Inter-Regular_ExtraBold"
    case InterRegualrExtraBlack = "Inter-Regular_Black"
}

extension UIFont {
    @nonobjc class func montserratExtraBold(size: CGFloat) -> UIFont {
        return UIFont(name: FontName.MontserratExtraBold.rawValue, size: size)!
    }
    
    @nonobjc class func interHeadline1() -> UIFont {
        return UIFont(name: FontName.InterRegualrBold.rawValue, size: 34)!
    }
    
    @nonobjc class func interHeadline2() -> UIFont {
        return UIFont(name: FontName.InterRegualrSemiBold.rawValue, size: 24)!
    }
    
    @nonobjc class func interHeadline3() -> UIFont {
        return UIFont(name: FontName.InterRegualrSemiBold.rawValue, size: 20)!
    }
    
    @nonobjc class func interHeadline4() -> UIFont {
        return UIFont(name: FontName.InterRegualrMedium.rawValue, size: 20)!
    }
    
    @nonobjc class func interSubtitle1() -> UIFont {
        return UIFont(name: FontName.InterRegualrSemiBold.rawValue, size: 18)!
    }
    
    @nonobjc class func interSubtitle2() -> UIFont {
        return UIFont(name: FontName.InterRegualrSemiBold.rawValue, size: 16)!
    }
    
    @nonobjc class func interSubtitle3() -> UIFont {
        return UIFont(name: FontName.InterRegualrSemiBold.rawValue, size: 14)!
    }
    
    @nonobjc class func interBody1() -> UIFont {
        return UIFont(name: FontName.InterRegualr.rawValue, size: 16)!
    }
    
    @nonobjc class func interBody2() -> UIFont {
        return  UIFont(name: FontName.InterRegualrMedium.rawValue, size: 14)!
    }
    
    @nonobjc class func interBody3() -> UIFont {
        return UIFont(name: FontName.InterRegualr.rawValue, size: 14)!
    }
    
    @nonobjc class func interCaption12() -> UIFont {
        return UIFont(name: FontName.InterRegualr.rawValue, size: 12)!
    }
    
    @nonobjc class func interCaption10() -> UIFont {
        return UIFont(name: FontName.InterRegualr.rawValue, size: 10)!
    }
    
    @nonobjc class func interNav() -> UIFont {
        return UIFont(name: FontName.InterRegualrSemiBold.rawValue, size: 10)!
    }
    
    @nonobjc class func interPretendard() -> UIFont {
        return UIFont(name: FontName.InterRegualrSemiBold.rawValue, size: 14)!
    }
}
