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
            role: role
        )
    }
}
