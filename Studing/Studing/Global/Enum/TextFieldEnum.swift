//
//  TextFieldEnum.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/23/24.
//

import UIKit

enum TextFieldState {
    case normal(type: TextFieldInputType)
    case success(type: TextFieldInputType)
    case duplicate(type: TextFieldInputType)
    case invalid(type: TextFieldInputType)
    
    var color: UIColor {
        switch self {
        case .normal:
            return .black10
        case .success:
            return .primary50
        case .duplicate, .invalid:
            return .studingRed
        }
    }
    
    var message: String {
        switch self {
        case .normal(let type):
            switch type {
            case .university:
                return "현재 등록된 학교만 보여드려요!"
            case .major:
                return  "현재 등록된 학과만 보여드려요!"
            default:
                return ""
            }
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
            default:
                return ""
            }
        }
    }
}

enum TextFieldInputType {
    case userId
    case userPw
    case confirmPw
    case userName
    case studentId
    case university
    case major
    
    var title: String {
        switch self {
        case .userId:
            return "아이디(최대 12자)"
        case .userPw:
            return "비밀번호"
        case .confirmPw:
            return "비밀번호 확인"
        case .userName:
            return "이름"
        case .studentId:
            return "전체 학번"
        case .university:
            return "대학교"
        case .major:
            return "전공학과"
        }
    }
    
    var placeholder: String {
        switch self {
        case .userId:
            return "ex. studing24"
        case .userPw:
            return "8자리 이상 입력해주세요"
        case .confirmPw:
            return "비밀번호를 다시 한 번 확인할게요"
        case .userName:
            return "이름을 입력해주세요"
        case .studentId:
            return "학번을 선택해주세요"
        case .university:
            return "대학교를 입력해주세요"
        case .major:
            return "학과를 입력해주세요"
        }
    }
}
