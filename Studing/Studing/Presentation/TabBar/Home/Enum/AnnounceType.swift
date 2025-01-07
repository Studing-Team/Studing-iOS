//
//  AnnouceType.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/22/24.
//

import UIKit

/// `AnnounceType` 열거형은 공지사항의 유형을 정의하며,
/// 일반 공지와 이벤트로 구분하여 각각의 시각적 스타일을 관리합니다.
///
/// - Note: 각 유형별로 제목 텍스트, 제목 색상, 배경 색상을 다르게 표시하여 사용자가 직관적으로 구분할 수 있도록 합니다.
///
/// ## 열거형의 각 케이스
///   - `annouce`: 일반 공지사항
///   - `event`: 이벤트 공지사항
///
/// ## 주요 프로퍼티
///   - `title`: 공지 유형의 표시 텍스트를 반환합니다.
///   - `titleColor`: 공지 유형별 제목 색상을 반환합니다.
///   - `backgroundColor`: 공지 유형별 배경 색상을 반환합니다.
///
enum AnnounceType {
    /// 일반 공지사항을 나타내는 케이스
    case annouce
    
    /// 이벤트 공지사항을 나타내는 케이스
    case event
    
    /// 공지 유형별 표시 텍스트를 반환하는 계산 프로퍼티
    var title: String {
        switch self {
        case .annouce:
            return "공지"
        case .event:
            return "이벤트"
        }
    }
    
    /// 공지 유형별 제목 색상을 반환하는 계산 프로퍼티
    var titleColor: UIColor {
        switch self {
        case .annouce:
            return .primary50
        case .event:
            return .red
        }
    }
    
    /// 공지 유형별 배경 색상을 반환하는 계산 프로퍼티
    var backgroundColor: UIColor {
        switch self {
        case .annouce:
            return .primary20
        case .event:
            return .red
        }
    }
}
