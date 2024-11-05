//
//  AssociationAnnounceListModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/22/24.
//

import Foundation

struct AssociationAnnounceListModel: Hashable, HomeSectionData {
    let id = UUID()
    let type: AnnouceType
    let title: String
    let contents: String
    let days: String
    let favoriteCount: Int
    let bookmarkCount: Int
    let watchCount: Int
    let isFavorite: Bool
    let isBookmark: Bool
}
