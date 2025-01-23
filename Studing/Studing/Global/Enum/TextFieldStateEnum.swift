//
//  TextFieldStateEnum.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/23/24.
//

import UIKit

/// `TextFieldState` 열거형은 텍스트 필드의 다양한 상태와 그에 따른 시각적 피드백을 관리합니다.
/// 각 상태는 일반(.normal), 선택(.select), 유효성 검사 성공(.validSuccess), 성공(.success),
/// 중복(.duplicate), 유효하지 않음(.invalid)으로 구성되며,
/// 각 상태에 따른 색상, 테두리 색상, 사용자 메시지를 제공합니다.
///
/// - Note: 각 상태는 TextFieldInputType을 연관값으로 가지며, 이를 통해 텍스트 필드의 용도에 따른 세부적인 처리가 가능합니다.
///
/// ## 열거형의 각 케이스
///  - `normal`: 기본 상태를 나타냅니다.
///  - `select`: 텍스트 필드가 선택된 상태를 나타냅니다.
///  - `validSuccess`: 입력값이 유효성 검사를 통과한 상태를 나타냅니다.
///  - `success`: 전체적인 검증이 성공한 상태를 나타냅니다.
///  - `duplicate`: 입력값이 중복된 상태를 나타냅니다.
///  - `invalid`: 입력값이 유효하지 않은 상태를 나타냅니다.
///
/// ## 주요 프로퍼티
///  - `color`: 각 상태에 따른 텍스트 필드의 색상을 반환합니다.
///  - `borderColor`: 각 상태에 따른 테두리 색상을 반환합니다.
///  - `message`: 각 상태에 따른 사용자 안내 메시지를 반환합니다.
///
enum TextFieldState {
    
    /// 기본 상태
    /// - Parameter type: 텍스트 필드의 입력 타입
    case normal(type: TextFieldInputType)
    
    /// 선택된 상태
    /// - Parameter type: 텍스트 필드의 입력 타입
    case select(type: TextFieldInputType)
    
    /// 유효성 검사 성공 상태
    /// - Parameter type: 텍스트 필드의 입력 타입
    case validSuccess(type: TextFieldInputType)
    
    /// 성공 상태
    /// - Parameter type: 텍스트 필드의 입력 타입
    case success(type: TextFieldInputType)
    
    /// 중복된 값 상태
    /// - Parameter type: 텍스트 필드의 입력 타입
    case duplicate(type: TextFieldInputType)
    
    /// 유효하지 않은 상태
    /// - Parameter type: 텍스트 필드의 입력 타입
    case invalid(type: TextFieldInputType)
    
    /// 텍스트 필드의 색상을 결정하는 계산 프로퍼티
    var color: UIColor {
        switch self {
        case .normal:
            return .black10
        case .select(let type):
            switch type {
            case .studentId:
                return .primary50
            default:
                return .black10
            }
        case .success, .validSuccess:
            return .primary50
        case .duplicate, .invalid:
            return .studingRed
        }
    }
    
    /// 테두리 색상을 결정하는 계산 프로퍼티
    var borderColor: CGColor {
        switch self {
        case .normal:
            return UIColor.black10.cgColor
        case .select(let type):
            switch type {
            case .studentId:
                return UIColor.primary50.cgColor
            default:
                return UIColor.black10.cgColor
            }
        case .success, .validSuccess:
            return UIColor.primary50.cgColor
        case .duplicate, .invalid:
            return UIColor.studingRed.cgColor
        }
    }
    
    /// 상태에 따른 메시지를 반환하는 계산 프로퍼티
    var message: String {
        switch self {
        case .normal:
            return ""
        case .success(let type):
            switch type {
            case .userId:
                return "사용 가능한 아이디에요"
            case .userPw:
                return "사용 가능한 비밀번호에요"
            case .confirmPw:
                return "비밀번호가 일치해요"
            default:
                return ""
            }
        case .duplicate(type: let type):
            switch type {
            case .userId:
                return "이미 사용 중인 아이디에요."
            case .userPw:
                return "사용 가능한 비밀번호에요"
            case .confirmPw:
                return "비밀번호가 일치해요"
            default:
                return "비밀번호가 일치하지 않아요"
            }
        case .invalid(type: let type):
            switch type {
            case .userId:
                return "영문, 숫자를 사용한 6자~12자를 입력해주세요"
            case .userPw:
                return "영문, 숫자, 특수문자를 각각 1개 이상 포함한 8~16로 입력해주세요"
            case .confirmPw:
                return "비밀번호가 일치하지 않아요"
            default:
                return ""
            }
        case .select(type: let type):
            switch type {
            case .university:
                return "현재 등록된 학교만 보여드려요!"
            case .major:
                return "현재 등록된 학과만 보여드려요!"
            default:
                return ""
            }
        default:
            return ""
        }
    }
}
