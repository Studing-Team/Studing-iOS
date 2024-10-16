//
//  CustomButtonEnum.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/15/24.
//

import UIKit

enum ButtonState {
    case activate
    case deactivate
}

enum ButtonStyle {
    case next
    case login
    case registerUniverstiy
    case registerMajor
    case authentication
    case notification
    case showStuding
    case duplicate
    case retry
    case studentCard
    case showStudingHome
    
    var title: String {
        switch self {
        case .next:
            return "다음"
        case .login:
            return "로그인"
        case .registerUniverstiy:
            return "우리 학교 등록하기"
        case .registerMajor:
            return "우리 학과 등록하기"
        case .authentication:
            return "인증하기"
        case .notification:
            return "알림 받기"
        case .showStuding, .showStudingHome:
            return "스튜딩 시작하기"
        case .duplicate:
            return "중복확인"
        case .retry:
            return "다시 시도"
        case .studentCard:
            return "학생증 업로드"
        }
    }
    
    var enableBackground: UIColor {
        switch self {
        case .next, .login, .registerUniverstiy, .registerMajor ,.authentication,  .notification, .duplicate, .retry, .studentCard:
            return .primary50
        case .showStuding:
            return .white
        case .showStudingHome:
            return .white.withAlphaComponent(0.1)
        }
    }
    
    var disableBackground: UIColor {
        switch self {
        case .next, .authentication:
            return .black20
        case .showStuding:
            return .white
        case .showStudingHome:
            return .white.withAlphaComponent(0.1)
        default:
            return .primary50
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .next, .login, .registerUniverstiy, .registerMajor, .authentication, .notification, .duplicate, .retry, .studentCard, .showStudingHome:
            return .white
            
        case .showStuding:
            return .black50
        }
    }
}
