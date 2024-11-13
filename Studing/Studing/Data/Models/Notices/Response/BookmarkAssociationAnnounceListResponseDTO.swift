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
