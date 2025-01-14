//
//  SerachResultType.swift
//  Studing
//
//  Created by ParkJunHyuk on 12/12/24.
//

import Foundation

/// `SerachResultType` 열거형은 검색 결과의 유형을 정의하며, 대학교와 전공 검색에 대한 결과 메시지를 관리합니다.
///
/// - Note: StringLiterals를 통해 일관된 메시지를 제공하며, 검색 결과가 없을 때 표시할 제목과 부제목을 포함합니다.
///
/// ## 열거형의 각 케이스
///   - `university`: 대학교 검색 결과
///   - `major`: 전공 검색 결과
///
/// ## 주요 프로퍼티
///   - `title`: 검색 결과 없음 상태의 제목 메시지를 반환합니다.
///   - `subTitle`: 검색 결과 없음 상태의 부제목 메시지를 반환합니다.
///
enum SerachResultType {
    /// 대학교 검색 결과를 나타내는 케이스
    case university
    
    /// 전공 검색 결과를 나타내는 케이스
    case major
    
    /// 검색 결과 없음 상태의 제목 메시지를 반환하는 계산 프로퍼티
    var title: String {
        switch self {
        case .university:
            return StringLiterals.Title.noExistsSerachUniversity
        case .major:
            return StringLiterals.Title.noExistsSerachMajor
        }
    }
    
    /// 검색 결과 없음 상태의 부제목 메시지를 반환하는 계산 프로퍼티
    var subTitle: String {
        switch self {
        case .university:
            return StringLiterals.SubTitle.noExistsSerachUniversity
        case .major:
            return StringLiterals.SubTitle.noExistsSerachMajor
        }
    }
}
