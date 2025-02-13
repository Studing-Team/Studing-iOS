//
//  TitleType.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/11/25.
//

import Foundation

/// `TitleType` 열거형은 공지사항 작성 화면의 각 섹션 제목을 정의하며,
/// TitleSectionHeaderView 에서 사용되어 각 입력 섹션을 구분합니다.
///
/// - Note: 각 케이스는 공지사항 작성에 필요한 특정 섹션을 나타내며,
///         해당하는 한글 제목을 반환하는 계산 프로퍼티를 포함합니다.
///
/// ## 열거형의 각 케이스
///   - `title`: 공지사항의 제목 섹션
///   - `content`: 공지사항의 내용 섹션
///   - `tag`: 태그 입력 섹션
///   - `period`: 기간 설정 섹션 (PostDisplayType에 따라 다름)
///   - `personNumber`: 선착순 인원 수 설정 섹션
///
enum TitleType: Equatable {
    /// 공지사항 제목 입력 섹션
    case title
    
    /// 공지사항 내용 입력 섹션
    case content
    
    /// 태그 입력 섹션
    case tag
    
    /// 기간 설정 섹션 (PostDisplayType에 따라 표시가 달라짐)
    case period(type: PostDisplayType)
    
    /// 선착순 인원 수 설정 섹션
    case personNumber
    
    /// 각 섹션의 한글 제목을 반환하는 계산 프로퍼티
    var title: String {
        switch self {
        case .title:
            return "제목"
        case .content:
            return "내용"
        case .tag:
            return "태그"
        case .period:
            return "기간"
        case .personNumber:
            return "선착순 인원 수"
        }
    }
}
