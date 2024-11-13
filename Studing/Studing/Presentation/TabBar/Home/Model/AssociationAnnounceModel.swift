//
//  AssociationAnnounceModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import Foundation

struct AssociationAnnounceModel: Hashable, HomeSectionData {
    let id = UUID()
    let title: String
    let contents: String
    let days: String
    let favoriteCount: Int
    let bookmarkCount: Int
    let watchCount: Int
    let isFavorite: Bool
    let isBookmark: Bool
}
