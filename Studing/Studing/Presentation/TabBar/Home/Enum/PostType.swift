//
//  PostType.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/11/25.
//

import Foundation

/// `PostType` 열거형은 게시글의 작성 상태를 정의하며,
/// 새로운 게시글 작성과 기존 게시글 수정을 구분합니다.
///
/// ## 열거형의 각 케이스
///   - `create`: 새로운 게시글 작성
///   - `edit`: 기존 게시글 수정
///
enum PostType {
    /// 새로운 게시글을 작성하는 케이스
    case create
    
    /// 기존 게시글을 수정하는 케이스
    case edit
}

/// `PostOptionType` 열거형은 게시글의 옵션 유형을 정의하며,
/// 기본, 기간 설정, 선착순 옵션으로 구분하여 각각의 UI 레이아웃을 관리합니다.
///
/// - Note: 각 옵션 유형별로 고유한 헤더 높이와 카운트 뷰 패딩 값을 가지며, UI 구성에 활용됩니다.
///
/// ## 열거형의 각 케이스
///   - `basic`: 기본 옵션
///   - `period`: 기간 설정 옵션 (시작 시간, 종료 시간 포함)
///   - `firstCome`: 선착순 옵션 (시작 시간, 종료 시간, 선착순 여부 포함)
///
/// ## 주요 프로퍼티
///   - `headerHeight`: 옵션 유형별 헤더 높이 값을 반환합니다.
///   - `countViewPadding`: 옵션 유형별 카운트 뷰 패딩 값을 반환합니다.
///
enum PostOptionType: Hashable {
    /// 기본 옵션을 나타내는 케이스
    case basic
    
    /// 기간 설정 옵션을 나타내는 케이스
    case period//(startTime: String, endTime: String)
    
    /// 선착순 옵션을 나타내는 케이스
    case firstCome//(startTime: String, endTime: String, isFirstCome: Bool)
    
    /// 옵션 유형별 헤더 높이 값을 반환하는 계산 프로퍼티
    var headerHeight: Int {
        switch self {
        case .basic:
            return 80
        case .period:
            return 176
        case .firstCome:
            return 228
        }
    }
    
    /// 옵션 유형별 이미지 카운트 뷰 패딩 값을 반환하는 계산 프로퍼티
    var countViewPadding: Int {
        switch self {
        case .basic:
            return 92
        case .period:
            return 188
        case .firstCome:
            return 240
        }
    }
}
