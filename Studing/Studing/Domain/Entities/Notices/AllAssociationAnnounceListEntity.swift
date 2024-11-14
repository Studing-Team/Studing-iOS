//
//  AllAssociationAnnounceListEntity.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/22/24.
//

import Foundation

struct AllAssociationAnnounceListEntity: Hashable, HomeSectionData {
    let id = UUID()
    let type: AnnounceType
    let title: String
    let contents: String
    let days: String
    let favoriteCount: Int
    let bookmarkCount: Int
    let imageUrl: String?
    let watchCount: Int
    let isFavorite: Bool
    let isBookmark: Bool
}
