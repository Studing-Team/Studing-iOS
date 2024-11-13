//
//  BookmarkAnnouceResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

struct BookmarkAnnouceData: Decodable {
   let notices: [BookmarkAnnouceResponseDTO]
}

struct BookmarkAnnouceResponseDTO: Decodable {
    let id: Int
    let affiliation: String
    let title: String
    let content: String
    let createdAt: String
    let saveCheck: Bool
}

extension BookmarkAnnouceResponseDTO {
    func toEntity() -> BookmarkAnnounceEntity {
        BookmarkAnnounceEntity(
            bookmarkId: self.id,
            association: self.affiliation, 
            associationType: convertToAssociationType(affiliation),
            title: self.title,
            contents: self.content,
            days: self.createdAt.formatDate(from: self.createdAt),
            saveCheck: self.saveCheck
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
