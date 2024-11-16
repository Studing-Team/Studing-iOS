//
//  DetailAnnouceImageModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import Foundation

struct DetailAnnouceImageModel: Hashable, DetailAnnouceSectionData {
    let id = UUID()
    let image: String?
}
