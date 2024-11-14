//
//  BookmarkListEntity.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/14/24.
//

import Foundation

struct BookmarkListEntity: Hashable, HomeSectionData {
    let id = UUID()
    let bookmarkId : Int
    let title: String
    let imageUrl: String
    let days: String
    let isBookmark: Bool
}
