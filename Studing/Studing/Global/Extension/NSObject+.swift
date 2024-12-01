//
//  NSObject+.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/3/24.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
