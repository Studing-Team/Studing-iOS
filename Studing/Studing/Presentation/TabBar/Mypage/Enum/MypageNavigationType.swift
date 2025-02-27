//
//  MypageNavigationType.swift
//  Studing
//
//  Created by ParkJunHyuk on 12/12/24.
//

import Foundation

/// `MypageNavigationType` 열거형은 마이페이지 화면에서 사용되는 네비게이션 메뉴 항목들을 정의합니다.
/// 사용자 정보 관리, 앱 설정, 정책 확인, 계정 관리 등 마이페이지의 모든 이동 가능한 항목들을 포함합니다.
///
/// - Note: 각 케이스는 마이페이지에서 특정 화면으로의 이동을 나타내며, 사용자 계정과 관련된 모든 기능을 포함합니다.
///
/// ## 열거형의 각 케이스
///   - `userInfo`: 회원 정보 수정 화면으로 이동
///   - `serviceCenter`: 고객센터 화면으로 이동
///   - `notice`: 공지사항 화면으로 이동
///   - `version`: 앱 버전 정보 화면으로 이동
///   - `terms`: 이용약관 화면으로 이동
///   - `privacyPolicy`: 개인정보 처리방침 화면으로 이동
///   - `alarmSetting`: 알람 설정 화면으로 이동
///   - `logout`: 로그아웃 기능
///   - `withDraw`: 회원탈퇴 기능
///
enum MypageNavigationType {
    /// 회원 정보 수정 화면
    case userInfo
    
    /// 고객센터 화면
    case serviceCenter
    
    /// 공지사항 화면
    case notice
    
    /// 앱 버전 정보 화면
    case version
    
    /// 이용약관 화면
    case terms
    
    /// 개인정보 처리방침 화면
    case privacyPolicy
    
    /// 알람 설정 화면
    case alarmSetting
    
    /// 로그아웃 기능
    case logout
    
    /// 회원탈퇴 기능
    case withDraw
}
