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
    let image: String
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
