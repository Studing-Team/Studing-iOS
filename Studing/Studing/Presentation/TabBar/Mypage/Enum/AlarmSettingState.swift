//
//  AlarmSettingState.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/27/25.
//

import UIKit

enum AlarmSettingState {
    case alarmOn
    case alamrOff
    
    var title: String {
        switch self {
        case .alamrOff:
            return "알림 켜기"
        case .alarmOn:
            return "알림 끄기"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .alamrOff:
            return .primary50
        case .alarmOn:
            return .primary20
        }
    }
    
    var fontColor: UIColor {
        switch self {
        case .alamrOff:
            return .white
        case .alarmOn:
            return .primary40
        }
    }
    
    var mainTitle: String {
        switch self {
        case .alamrOff:
            return "알림을 켜주세요"
        case .alarmOn:
            return "알림이 켜져있어요"
        }
    }
    
    var subTitle: String {
        switch self {
        case .alamrOff:
            return "새로운 공지와 이벤트 소식을 받아보세요"
        case .alarmOn:
            return "새로운 공지와 이벤트 소식을 받고 있어요"
        }
    }
}
