//
//  AssociationAnnounceEntity.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

struct AssociationAnnounceEntity: Hashable, HomeSectionData {
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
    let imageURL: String?
}
