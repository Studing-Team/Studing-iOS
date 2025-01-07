//
//  AssociationType.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import UIKit

/// `AssociationType` 열거형은 학교 내 학생 조직의 유형을 정의하며,
/// 총학생회, 단과대, 학과별로 구분하여 각각의 시각적 스타일을 관리합니다.
///
/// - Note: 각 조직 유형별로 고유한 색상과 배경색을 가지며, 표시 이름을 통해 사용자가 쉽게 구분할 수 있도록 합니다.
///
/// ## 열거형의 각 케이스
///   - `generalStudents`: 총학생회 조직
///   - `college`: 단과대 조직
///   - `major`: 학과 조직
///
/// ## 주요 프로퍼티
///   - `titleColor`: 조직 유형별 제목 색상을 반환합니다.
///   - `backgroundColor`: 조직 유형별 배경 색상을 반환합니다.
///   - `typeName`: 조직 유형의 표시 이름을 반환합니다.
///
enum AssociationType {
    /// 총학생회를 나타내는 케이스
    case generalStudents
    
    /// 단과대 학생회를 나타내는 케이스
    case college
    
    /// 학과 학생회를 나타내는 케이스
    case major
    
    /// 조직 유형별 제목 색상을 반환하는 계산 프로퍼티
    var titleColor: UIColor {
        switch self {
        case .generalStudents:
            return .primary50
        case .college:
            return .studingRed
        case .major:
            return .studingMajor
        }
    }
    
    /// 조직 유형별 배경 색상을 반환하는 계산 프로퍼티
    var backgroundColor: UIColor {
        switch self {
        case .generalStudents:
            return .primary10
        case .college:
            return .red5
        case .major:
            return .studingMajorBackgroud
        }
    }
    
    /// 조직 유형별 표시 이름을 반환하는 계산 프로퍼티
    var typeName: String {
        switch self {
        case .generalStudents:
            return "총학생회"
        case .college:
            return "단과대"
        case .major:
            return "학과"
        }
    }
}
