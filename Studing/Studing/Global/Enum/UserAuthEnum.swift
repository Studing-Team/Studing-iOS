//
//  UserAuthEnum.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/16/24.
//

import Foundation

/// `UserAuth` 열거형은 사용자 인증 상태를 정의합니다.
///
/// ## 열거형의 각 케이스
///   - `unUser`: 제출 완료, 인증되지 않은 상태를 나타냅니다.
///  - `failureUser`: 제출 완료, 인증에 실패한 상태를 나타냅니다.
///  - `successUser`: 제출 완료, 인증이 성공한 상태를 나타냅니다.
///  - `universityUser`: 총학생회 계정 상태를 나타냅니다.
///  - `collegeUser`: 단과대학 계정 상태를 나타냅니다.
///  - `departmentUser`: 학과 계정 상태를 나타냅니다.
///
enum UserAuth: String {
    case unUser = "unUser" // 제출 완료, 인증 x
    case failureUser = "failureUser" // 제출 완료, 인증 실패
    case successUser = "successUser"  // 제출 완료, 인증 o
    case universityUser = "universityUser" // 총학 계정
    case collegeUser = "collegeUser" // 단과대 계정
    case departmentUser = "departmentUser" // 학과 계정
}
