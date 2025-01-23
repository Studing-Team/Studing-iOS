//
//  MenuType.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/22/25.
//

import UIKit

enum MenuType: CaseIterable {
    case edit
    case delete
    
    var title: String {
        switch self {
        case .edit:
            return "수정하기"
        case .delete:
            return "삭제하기"
        }
    }
    
    var textColor: UIColor {
        return .black50
    }
    
    var font: UIFont {
        return .interBody1()
    }
    
    var menuImage: UIImage {
        switch self {
        case .edit:
            return UIImage(resource: .editMenu)
        case .delete:
            return UIImage(resource: .deleteMenu)
        }
    }
}
