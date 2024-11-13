//
//  AnnouceType.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/22/24.
//

import UIKit

enum AnnounceType {
    case annouce
    case event
    
    var title: String {
        switch self {
        case .annouce:
            return "공지"
        case .event:
            return "이벤트"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .annouce:
            return .primary50
        case .event:
            return .red
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .annouce:
            return .primary20
        case .event:
            return .red
        }
    }
}
