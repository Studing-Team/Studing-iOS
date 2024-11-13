//
//  MypageInfoResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/12/24.
//

import Foundation

struct MypageInfoResponseDTO: Decodable {
    let amissionNumber: Int
    let name: String
    let memberUniversity: String
    let memberDepartment: String
    let role: String
}
