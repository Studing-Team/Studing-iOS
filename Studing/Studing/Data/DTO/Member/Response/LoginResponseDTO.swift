//
//  LoginResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

struct LoginResponseDTO: Decodable {
    let accessToken: String
    let memberData: UserInfoResponseDTO
}

struct UserInfoResponseDTO: Decodable {
    let id: Int
    let loginIdentifier: String
    let name: String
    let memberUniversity: String
    let memberDepartment: String
    let role: String
}

extension UserInfoResponseDTO {
    func toEntity()  -> UserInfoEntity {
        return UserInfoEntity(
            id: id,
            loginIdentifier: loginIdentifier,
            name: name,
            memberUniversity: memberUniversity,
            memberDepartment: memberDepartment,
            role: convertRoleToUserAuth())
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
