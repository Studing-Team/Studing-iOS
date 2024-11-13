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
    let images: [String]
}
