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
