//
//  DetailAnnouceHeaderModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import Foundation

protocol DetailAnnouceSectionData {}

struct DetailAnnouceHeaderModel: Hashable, DetailAnnouceSectionData {
    let id = UUID()
    let name: String
    let image: String
    let days: String
    var favoriteCount: Int
    var bookmarkCount: Int
    let watchCount: Int
    var isFavorite: Bool
    var isBookmark: Bool
}
