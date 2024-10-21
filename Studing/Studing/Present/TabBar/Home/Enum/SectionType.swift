//
//  SectionType.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import Foundation

/// `SectionType`은 UICollection 의 Section 을 구분하는 열거형입니다.
/// 놓친 공지사항(missAnnouce), 학생회(association), 학생회 공지사항(annouce),
/// 저장한 공지사항(bookmark), 비어있는 북마크(emptyBookmark) 5가지 섹션 타입을 정의합니다.
///
/// - Cases:
///   - missAnnouce: 사용자가 확인하지 않은, 놓친 공지사항을 표시하는 섹션
///   - association: 가입한 학생회를 표시하는 섹션
///   - annouce: 학생회에서 올린 공지사항을 표시하는 섹션
///   - bookmark: 사용자가 저장한 공지사항을 표시하는 섹션
///   - emptyBookmark: 북마크가 비어있을 때를 처리하는 섹션
enum SectionType: CaseIterable {
    case missAnnouce
    case association
    case annouce
    case bookmark
    case emptyBookmark
}
