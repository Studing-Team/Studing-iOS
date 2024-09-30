//
//  SizeLiterals.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/25/24.
//

import UIKit

struct SizeLiterals {
    struct Screen {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let screenHeight: CGFloat = UIScreen.main.bounds.height
        static let deviceRatio: CGFloat = screenWidth / screenHeight
    }
}
