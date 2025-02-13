//
//  CustomButtonEnum.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/15/24.
//

import UIKit

/// `ButtonState` 열거형은 버튼의 활성 상태를 정의합니다.
///
/// - Cases:
///   - activate: 버튼이 활성화된 상태를 나타냅니다.
///   - deactivate: 버튼이 비활성화된 상태를 나타냅니다.
enum ButtonState {
    case activate
    case deactivate
}

enum CloseType {
    case gray
    case blue
}

enum ConfirmType {
    case event
    case normal
}

enum ButtonStyle: Equatable {
    /// `ButtonStyle` 열거형은 버튼 스타일을 정의하며, 각 스타일에 따라 버튼의 제목,
    /// 배경색, 활성 상태 및 비활성 상태를 설정합니다.
    ///
    /// ## 열거형의 각 케이스
    ///   - next: "다음" 버튼입니다.
    ///  - login: "로그인" 버튼입니다.
    ///  - registerUniverstiy: "우리 학교 등록하기" 버튼입니다.
    ///  - registerMajor: "우리 학과 등록하기" 버튼입니다.
    ///  - authentication: "인증하기" 버튼입니다.
    ///  - notification: "알림 받기" 버튼입니다.
    ///  - showStuding: "스튜딩 시작하기" 버튼입니다.
    ///  - duplicate: "중복확인" 버튼입니다.
    ///  - retry: "다시 시도" 버튼입니다.
    ///  - studentCard: "학생증 업로드" 버튼입니다.
    ///  - postAnnounce: "등록하기" 버튼입니다.
    ///  - home: "홈으로 돌아가기" 버튼입니다.
    ///  - showStudingHome: "스튜딩 시작하기" 버튼으로, 일부 투명도가 적용됩니다.
    ///  - close: "닫기" 버튼입니다. `CloseType`에 따라 색상 다름.
    ///  - startDay: "시작 날짜 선택" 버튼입니다.
    ///  - endDay: "종료 날짜 선택" 버튼입니다.
    ///  - startTime: "시작 시간 선택" 버튼입니다.
    ///  - endTime: "종료 시간 선택" 버튼입니다.
    ///  - myRanking: "내 순위 조회" 버튼입니다.
    
    /// 다음 버튼
    case next
    
    /// 로그인 버튼
    case login
    
    /// 우리 학교 등록하기 버튼
    case registerUniverstiy
    
    /// 우리 학과 등록하기 버튼
    case registerMajor
    
    /// 인증하기 버튼
    case authentication
    
    /// 알림 받기 버튼
    case notification
    
    /// 스튜딩 시작하기 버튼
    case showStuding
    
    /// 중복확인 버튼
    case duplicate
    
    /// 다시 시도 버튼
    case retry
    
    /// 학생증 업로드 버튼
    case studentCard
    
    /// 스튜딩 시작하기 버튼(Home 으로 이동)
    case showStudingHome
    
    /// 등록하기 버튼
    case postAnnounce
    
    /// 게시글 수정하기 버튼
    case editAnnounce
    
    /// 홈으로 돌아가기 버튼
    case home
    
    /// 닫기 버튼, `CloseType`에 따라 다르게 동작
    case close(type: CloseType)
    
    /// 시작 날짜 선택 버튼
    case startDay
    
    /// 종료 날짜 선택 버튼
    case endDay
    
    /// 시작 시간 선택 버튼
    case startTime
    
    /// 종료 시간 선택 버튼
    case endTime
    
    /// 내 순위 조회 버튼
    case myRanking
    
    /// 취소 버튼
    case cancel
    
    /// 확인 버튼
    case confirm(type: ConfirmType)
    
    case alarmDay
    
    case alarmTime
    
    case delete
    
    case yes
    
    case no
    
    case withdraw
    
    /// 버튼 제목을 반환합니다.
    ///
    /// - Returns: 버튼 스타일에 따라 적절한 제목 문자열(`String`)을 반환합니다.
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
        case .postAnnounce:
            return "등록하기"
        case .home:
            return "홈으로 돌아가기"
        case .close:
            return "닫기"
        case .startDay:
            return "시작 날짜 선택"
        case .endDay:
            return "종료 날짜 선택"
        case .startTime:
            return "시작 시간 선택"
        case .endTime:
            return "종료 시간 선택"
        case .editAnnounce:
            return "수정하기"
        case .myRanking:
            return "내 순위는?"
        case .cancel:
            return "취소"
        case .confirm:
            return "확인"
        case .alarmDay:
            return "알람 날짜 선택"
        case .alarmTime:
            return "알람 시간 선택"
        case .delete:
            return "삭제하기"
        case .yes:
            return "네"
        case .no:
            return "아니요"
        case .withdraw:
            return "탈퇴하기"
        }
    }
    
    /// 버튼이 활성 상태일 때 배경색을 반환합니다.
    ///
    /// - Returns: 버튼이 활성 상태일 때 적용될 배경색(`UIColor`)입니다.
    var enableBackground: UIColor {
        switch self {
        case .next, .login, .registerUniverstiy, .registerMajor, .authentication, .notification, .duplicate, .retry, .studentCard, .postAnnounce, .home, .startDay, .endDay, .startTime, .endTime, .editAnnounce, .alarmDay, .alarmTime, .delete, .yes, .no:
            return .primary50
        case .showStuding:
            return .white
        case .showStudingHome:
            return .white.withAlphaComponent(0.1)
        case .close(let type):
            if type == .blue {
                return .primary50
            } else {
                return .black20
            }
        case .myRanking:
            return .studingRedButton
        case .cancel, .withdraw:
            return .black20
            
        case .confirm(let type):
            if type == .event {
                return .studingRedButton
            } else {
                return .primary50
            }
        }
    }
    
    /// 버튼이 비활성 상태일 때 배경색을 반환합니다.
    ///
    /// - Returns: 버튼이 비활성화 상태일 때 적용될 배경색(`UIColor`)입니다.
    var disableBackground: UIColor {
        switch self {
        case .next, .authentication, .postAnnounce, .alarmDay, .alarmTime:
            return .black20
        case .showStuding:
            return .white
        case .showStudingHome:
            return .white.withAlphaComponent(0.1)
        default:
            return .primary50
        }
    }
    
    /// 버튼의 글자 색상을 반환합니다.
    ///
    /// - Returns: 버튼 상태에 맞는 색상(`UIColor`)입니다.
    var foregroundColor: UIColor {
        switch self {
        case .next, .login, .registerUniverstiy, .registerMajor, .authentication, .notification, .duplicate, .retry, .studentCard, .showStudingHome, .postAnnounce, .home, .close, .startDay, .endDay, .startTime, .endTime, .editAnnounce, .myRanking, .cancel, .confirm, .alarmDay, .alarmTime,  .delete, .yes, .no, .withdraw:
            return .white
            
        case .showStuding:
            return .black50
        }
    }
}
