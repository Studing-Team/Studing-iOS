//
//  DetailAnnouceContentModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import Foundation

struct DetailAnnouceContentModel: Hashable, DetailAnnouceSectionData {
    let id = UUID()
    let type: AnnouceType
    let title: String
    let content: String
}
