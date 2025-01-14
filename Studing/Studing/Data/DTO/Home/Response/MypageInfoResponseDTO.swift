//
//  MypageInfoResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/12/24.
//

import Foundation

struct MypageInfoResponseDTO: Decodable {
    let admissionNumber: Int
    let name: String
    let memberUniversity: String
    let memberDepartment: String
    let role: String
}

extension MypageInfoResponseDTO {
    func toEntity() -> MypageInfoEntity {
        MypageInfoEntity(
            userName: name,
            university: memberUniversity,
            major: memberDepartment,
            studentId: String(admissionNumber),
            role: convertRoleToUserAuth()
        )
    }
    
    func convertRoleToUserAuth() -> UserAuth {
        if role == "ROLE_UNUSER" {
            return .unUser
        } else if role == "ROLE_DENY" {
            return .failureUser
        } else if role == "ROLE_USER" {
            return .successUser
        } else if role == "ROLE_UNIVERSITY" {
            return .universityUser
        } else if role == "ROLE_COLLEGE" {
            return .collegeUser
        } else {
            return .departmentUser
        }
    }
}
