//
//  AllAssociationAnnounceEntity.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

struct AllAnnounceEntity: Hashable, HomeSectionData {
    let id = UUID()
    let announceId: Int
    let associationType: AssociationType
    let title: String
    let contents: String
    let writerInfo: String
    let days: String
    let favoriteCount: Int
    let bookmarkCount: Int
    let watchCount: Int
    let isFavorite: Bool
    let isBookmark: Bool
    let imageUrl: String?
}
