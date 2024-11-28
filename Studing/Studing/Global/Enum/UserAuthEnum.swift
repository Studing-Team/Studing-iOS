//
//  UserAuthEnum.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/16/24.
//

import Foundation

enum UserAuth: String {
    case unUser = "unUser" // 제출 완료, 인증 x
    case failureUser = "failureUser" // 제출 완료, 인증 실패
    case successUser = "successUser"  // 제출 완료, 인증 o
    case universityUser = "universityUser" // 총학 계정
    case collegeUser = "collegeUser" // 단과대 계정
    case departmentUser = "departmentUser" // 학과 계정
}
