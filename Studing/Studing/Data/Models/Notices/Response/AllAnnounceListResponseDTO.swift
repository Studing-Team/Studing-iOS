//
//  AllAnnounceListResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

struct AllAnnounceListResponseData: Decodable {
    let notices: [AllAnnounceListResponseDTO]
}

struct AllAnnounceListResponseDTO: Decodable {
    let id: Int
    let title: String
    let content: String
    let writerInfo: String
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
        case writerInfo
        case likeCount = "noticeLike"
        case saveCount
        case image
        case createdAt
        case readCount = "viewCount"
        case saveCheck
        case likeCheck
    }
}

extension AllAnnounceListResponseData {
    func toEntities() -> [AllAnnounceEntity] {
        return notices.map { $0.toEntity() }
    }
}

extension AllAnnounceListResponseDTO {
    func toEntity() -> AllAnnounceEntity {
        return AllAnnounceEntity(
            announceId: id,
            associationType: convertToAssociationType(writerInfo),
            title: title,
            contents: content,
            writerInfo: writerInfo,
            days: createdAt.formatDate(from: createdAt),
            favoriteCount: likeCount,
            bookmarkCount: saveCount,
            watchCount: readCount,
            isFavorite: likeCheck,
            isBookmark: saveCheck,
            imageUrl: image
        )
    }
    
    func convertToAssociationType(_ affiliation: String) -> AssociationType {
        
        let lastTwoCharacters = String(affiliation.suffix(2))
        
        if lastTwoCharacters == "대학" {
            return .college
        } else if lastTwoCharacters == "생회" {
            return .generalStudents
        } else {
            return .major
        }
    }
}
