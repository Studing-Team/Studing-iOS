//
//  FirstComeRankingsResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/24/25.
//

import Foundation

struct FirstComeRankingsResponseData: Decodable {
    let rankings: [FirstComeRankingsResponseDTO]
    let myRanking: Int
}

struct FirstComeRankingsResponseDTO: Decodable {
    let orderNumber: Int
    let applyDateTime: String
    let maskedStudentNumber: String
}

extension FirstComeRankingsResponseData {
    func toModels() -> [FirstComeRankingsModel] {
        return rankings.map { $0.toModel() }
    }
}

extension FirstComeRankingsResponseDTO {
    func toModel() -> FirstComeRankingsModel {
        return FirstComeRankingsModel(
            orderNumber: String(orderNumber),
            applyDateTime: applyDateTime,
            maskedStudentNumber: maskedStudentNumber
        )
    }
}

struct FirstComeRankingsModel {
    let orderNumber: String
    let applyDateTime: String
    let maskedStudentNumber: String
}
