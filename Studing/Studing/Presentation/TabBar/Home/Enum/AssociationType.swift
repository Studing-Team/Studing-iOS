//
//  AssociationType.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import UIKit

enum AssociationType {
    case generalStudents
    case college
    case major
    
    var titleColor: UIColor {
        switch self {
        case .generalStudents:
            return .primary50
        case .college:
            return .studingRed
        case .major:
            return .studingMajor
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .generalStudents:
            return .primary10
        case .college:
            return .red5
        case .major:
            return .studingMajorBackgroud
        }
    }
    
    var typeName: String {
        switch self {
        case .generalStudents:
            return "총학생회"
        case .college:
            return "단과대"
        case .major:
            return "학과"
        }
    }
}
