//
//  UnreadAllAnnounceListResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

struct UnreadAllAnnounceListResponseData: Decodable {
    let notices: [UnreadAllAnnounceListResponseDTO]
}

struct UnreadAllAnnounceListResponseDTO: Decodable {
    let id: Int
    let title: String
    let content: String
    let likeCount: Int
    let saveCount: Int
    let readCount: Int
    let createdAt: String
    let affilitionName: String
    let logoImage: String
    let tag: String
    let images: [String]?
    let saveCheck: Bool
    let likeCheck: Bool
}

extension UnreadAllAnnounceListResponseDTO {
    func convertToHeader() -> DetailAnnouceHeaderModel {
        return DetailAnnouceHeaderModel(
            name: affilitionName,
            image: logoImage,
            days: createdAt.formatDate(from: createdAt),
            favoriteCount: likeCount,
            bookmarkCount: saveCount,
            watchCount: readCount,
            isFavorite: likeCheck,
            isBookmark: saveCheck)
    }
    
    func convertToContent() -> DetailAnnouceContentModel {
        return DetailAnnouceContentModel(
            type: tag == "공지" ? .annouce : .event,
            title: title,
            content: content
        )
    }
    
    func convertToImages() -> [DetailAnnouceImageModel]? {
        return images?.compactMap{ DetailAnnouceImageModel(image: $0) }
    }
}
