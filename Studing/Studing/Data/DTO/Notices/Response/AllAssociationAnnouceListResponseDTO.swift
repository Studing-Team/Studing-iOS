//
//  AllAssociationAnnouceListResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

struct AllAssociationAnnounceListResponseData: Decodable {
    let notices: [AllAssociationAnnouceListResponseDTO]
}

struct AllAssociationAnnouceListResponseDTO: Decodable {
    let id: Int
    let title: String
    let content: String
    let tag: String
    let likeCount: Int
    let readCount: Int
    let saveCount: Int
    let image: String?
    let createdAt: String
    let saveCheck: Bool
    let likeCheck: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case tag
        case likeCount = "noticeLike"
        case saveCount
        case image
        case createdAt
        case readCount = "viewCount"
        case saveCheck
        case likeCheck
    }
}

extension AllAssociationAnnounceListResponseData {
    func toEntities() -> [AllAssociationAnnounceListEntity] {
        return notices.map { $0.toEntity() }
    }
}

extension AllAssociationAnnouceListResponseDTO {
    func toEntity() -> AllAssociationAnnounceListEntity {
        return AllAssociationAnnounceListEntity(
            announceId: id,
            type: convertToAnnounceType(type: tag),
            title: title,
            contents: content,
            days: createdAt.formatDate(from: createdAt),
            favoriteCount: likeCount,
            bookmarkCount: saveCount, 
            imageUrl: image,
            watchCount: readCount,
            isFavorite: likeCheck,
            isBookmark: saveCheck
        )
    }
    
    func convertToAnnounceType(type: String) -> AnnounceType {
        if type == "공지" {
            return .annouce
        } else {
            return .event
        }
    }
}
