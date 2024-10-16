//
//  AuthWaitStateEnum.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/16/24.
//

import UIKit

enum AuthWaitState: Int {
    case summit = 1
    case checking = 2
    case checked = 3
    case complete = 4
    case failure = 5
    
    func font(step: Int) -> UIFont {
        if step <= self.rawValue {
            return .interSubtitle3()
        } else {
            return .interBody2()
        }
    }
    
    func fontColor(step: Int) -> UIColor {
        if step <= self.rawValue {
            return .primary50
        } else {
            return .black30
        }
    }
    
    func stateImage(step: Int) -> UIImage {
        
        switch self {
        case .summit:
            if step == 1 {
                return UIImage(resource: .summit)
            } else {
                return UIImage(resource: .notCheck)
            }
            
        case .checking:
            if step == 1 {
                return UIImage(resource: .summit)
            } else if step == 2 {
                return UIImage(resource: .checking)
            } else {
                return UIImage(resource: .notCheck)
            }
            
        case .checked:
            if step == 1 || step == 3 {
                return UIImage(resource: .summit)
            } else {
                return UIImage(resource: .notCheck)
            }
            
        case .complete:
            return UIImage(resource: .summit)
            
        case .failure:
            if step < 5 {
                return UIImage(resource: .summit)
            } else {
                return UIImage(resource: .failure)
            }
        }
    }
}
