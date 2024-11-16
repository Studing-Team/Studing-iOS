//
//  PartnerInfoResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/15/24.
//

import Foundation

struct PartnerInfoResponseData: Decodable {
    let partners: [PartnerInfoResponseDTO]
}

struct PartnerInfoResponseDTO: Decodable {
    let id: Int
    let partnerName: String
    let partnerDescription: String
    let partnerAddress: String
    let category: String
    let partnerContent: String
    let latitude: Double
    let longitude: Double
    let partnerLogo: String
}

extension PartnerInfoResponseData {
    func toEntities() -> [StoreEntity] {
        return partners.map { $0.converToStoreEntity() }
    }
}

extension PartnerInfoResponseDTO {
    func converToStoreEntity() -> StoreEntity {
        return StoreEntity(
            storeId: id,
            name: partnerName,
            category: convertToType(category),
            description: partnerDescription,
            address: partnerAddress,
            imageURL: partnerLogo,
            latitude: latitude,
            longitude: longitude
        )
    }
    
    func convertToType(_ category: String) -> CategoryType {
        switch category {
        case "음식점":
            return .restaurant
        case "카페":
            return .coffee
        case "운동":
            return .exercise
        case "문화":
            return .culture
        case "주점":
            return .bar
        case "병원":
            return .health
        default:
            return .all
        }
    }
}
