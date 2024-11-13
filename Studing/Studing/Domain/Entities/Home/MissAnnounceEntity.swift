//
//  MissAnnounceModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import Foundation

struct MissAnnounceEntity: Hashable, HomeSectionData {
    let id = UUID()
    var userName: String
    var missAnnounceCount: Int
}
