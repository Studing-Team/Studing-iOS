//
//  BookmarkAnnounceEntity.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

struct BookmarkAnnounceEntity: Hashable, HomeSectionData {
    let id = UUID()
    let bookmarkId: Int
    let association: String
    let associationType: AssociationType
    let title: String
    let contents: String
    let days: String
    var saveCheck: Bool
}
