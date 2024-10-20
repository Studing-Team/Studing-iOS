//
//  BookmarkModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import Foundation

struct BookmarkModel: Hashable, HomeSectionData {
    let id = UUID()
    let association: String
    let title: String
    let contents: String
    let days: String
}
