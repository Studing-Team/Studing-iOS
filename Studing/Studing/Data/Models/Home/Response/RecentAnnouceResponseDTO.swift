//
//  RecentAnnouceResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

struct RecentAnnouncementData: Decodable {
   let notices: [AnnouncementResponseDTO]
}

struct AnnouncementResponseDTO: Decodable {
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

extension AnnouncementResponseDTO {
    func toEntity() -> AssociationAnnounceEntity {
        AssociationAnnounceEntity(
            announceId: self.id, 
            associationType: convertToAssociationType(writerInfo),
            title: self.title,
            contents: self.content,
            writerInfo: self.writerInfo,
            days: self.createdAt.formatDate(from: self.createdAt),
            favoriteCount: self.likeCount,
            bookmarkCount: self.saveCount,
            watchCount: self.readCount,
            isFavorite: self.likeCheck,
            isBookmark: self.saveCheck,
            imageURL: self.image
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
