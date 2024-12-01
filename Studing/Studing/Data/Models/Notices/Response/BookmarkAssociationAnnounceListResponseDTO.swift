//
//  BookmarkAssociationAnnouceListResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

struct BookmarkAssociationAnnounceListResponseData: Decodable {
    let notices: [BookmarkAssociationAnnounceListResponseDTO]
}

struct BookmarkAssociationAnnounceListResponseDTO: Decodable {
    let id: Int
    let title: String
    let createdAt: String
    let image: String
    let saveCheck: Bool
}

extension BookmarkAssociationAnnounceListResponseData {
    func toEntities() -> [BookmarkListEntity] {
        return notices.map { $0.toEntity() }
    }
}

extension BookmarkAssociationAnnounceListResponseDTO {
    func toEntity() -> BookmarkListEntity {
        return BookmarkListEntity(
            bookmarkId: id,
            title: title,
            imageUrl: image,
            days: createdAt.formatDate(from: createdAt),
            isBookmark: saveCheck
        )
    }
}
